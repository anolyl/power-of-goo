extends StaticBody2D

signal hasDied

export (PackedScene) var projectileTemplate

onready var muzzle = $ShootFromHere
onready var sprite = $Sprite

var projectileParent

var slimed
var target
var hitPos
var canShoot

func setup_projectileParent(projectileParentIN):
	projectileParent = projectileParentIN

func _ready():
	randomize()
	slimed = false
	canShoot = true
	$Sprite.play("idle")

func _process(_delta):
	#update()
	if target and not slimed:
		aim()
		update_face_direction()

func collided_with_slimeBall(slimeBall):
	slimed = true
	$AnimationPlayer.play("stunned")
	$SlimedParticle.show()
	$GetSlimedParticle.emitting = true
	$GetSlimedParticleOuter.emitting = true
	$SlimedTimer.start()
	$AudioStreamPlayer.play()
	flash()
	slimeBall.queue_free()

func collided_with_playerAttack():
	if slimed:
		var root = get_tree().get_root()
		var main = root.get_node("main")
		var libraries = main.get_node("Libraries")
		var saveManager = libraries.get_node("saveManager")

		var currentLevelHolder = main.get_node("CurrentLevel")
		var currentLevel = currentLevelHolder.get_children()[0]

		saveManager.append_to_be_destroyed(currentLevel, self)
		emit_signal("hasDied", global_position)
		queue_free()


func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		target = body


func _on_Detection_body_exited(body):
	if body == target:
		target = null
		if not slimed:
			$Sprite.play("idle")
			$AnimationPlayer.stop()

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position + muzzle.position, target.position, [self], collision_mask)
	if result:
		hitPos = result.position
		if result.collider.is_in_group("Player") or result.collider.is_class("RigidBody2D") and not slimed:
			$AnimationPlayer.play("attack")
		else:
			$Sprite.play("idle")
			$AnimationPlayer.stop()

func _draw():
	if target and hitPos:
		draw_circle(hitPos - position, 5, Color(1, 0, 0))
		draw_line(muzzle.position, hitPos - position, Color(1, 0, 0))

func shoot():
	var newProjectile = projectileTemplate.instance()
	if target:
		newProjectile.setup((target.global_position - muzzle.global_position).normalized() + Vector2(rand_range(-.5, .5), rand_range(-.5, .5)))
		newProjectile.global_position = muzzle.global_position
	
	projectileParent.add_child(newProjectile)

func flash():
	sprite.material.set_shader_param("flash_modifier", 1)
	$FlashTimer.start()


func _on_FlashTimer_timeout():
	var current_modifier = sprite.material.get_shader_param("flash_modifier")
	sprite.material.set_shader_param("flash_modifier", current_modifier - .1)
	if not current_modifier - .1 <= 0:
		$FlashTimer.start()

func update_face_direction():
	if target.global_position.x < global_position.x:
		$Sprite.flip_h = false
		muzzle.position.x = -22
	else:
		$Sprite.flip_h = true
		muzzle.position.x = 22


func _on_SlimedTimer_timeout():
	slimed = false
	$AnimationPlayer.play("RESET")
	$SlimedParticle.hide()

func impact_pause(time):
	$Sprite.pause_mode = true
	$ImpactTimer.wait_time = time
	$ImpactTimer.start()


func _on_ImpactTimer_timeout():
	$Sprite.pause_mode = false
