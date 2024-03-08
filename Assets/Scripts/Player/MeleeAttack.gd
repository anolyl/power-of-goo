extends Node2D

var fist_velocity = Vector2.RIGHT
var fist_speed = 2000

onready var fist = $Fist
onready var fistNPR = $NinePatchRect
onready var originalPosition

var isFlying = false
export var canPunch = true

var user

func setup(userIN):
	user = userIN

func _ready():
	originalPosition = position
	fistNPR.rect_size.y = 50
	set_physics_process(false)
	$Fist/Detection/CollisionShape2D.disabled = true

func hit(dir):
	if not isFlying and canPunch:
		isFlying = true
		canPunch = false
		fistNPR.rect_size.x = 0
		fist.global_position = owner.global_position
		look_at(global_position + dir)
		fist_velocity = dir * fist_speed
		show()
		$Fist/Detection/CollisionShape2D.disabled = false
		$AnimationPlayer.play("startHit")
		user.play_sound("swing")
		if not user.is_on_floor():
			var oldVelocity = user.get_velocity()
			user.freeze()
			yield(get_tree().create_timer(.25), "timeout")
			user.resume(oldVelocity)

func _physics_process(delta):
	if (fist.global_position - owner.global_position).length() <= 200 and isFlying:
		fistNPR.rect_size.x += (fist_velocity * delta).length()
		fistNPR.rect_position.y = -23
		fist_velocity = fist.move_and_slide(fist_velocity)
	else:
		collided()

func _on_Detection_body_entered(body):
	if body.has_method("collided_with_playerAttack"):
		body.collided_with_playerAttack()
		user.play_sound("swingHit")
	if body.has_method("collided_to_cage"):
		body.collided_to_cage(get_parent())
		user.play_sound("swingHit")
	collided()

func collided():
	isFlying = false
	set_physics_process(false)
	$Timer.createTimer(.3, funcref(self, "pull_back_fist"), [], false)
	$Fist/Detection/CollisionShape2D.set_deferred("disabled", true)
	
func pull_back_fist():
	$AnimationPlayer.play("pullBack")
