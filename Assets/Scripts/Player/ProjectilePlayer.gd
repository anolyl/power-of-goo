extends RigidBody2D

export var speed = 800

func setup(dir, color = Color(255, 255, 255)):
	linear_velocity = dir.normalized() * speed
	#$Node2D/Sprite.modulate = color

func _ready():
	$Node2D/Sprite.play("default")

func _process(_delta):
	fix_rotation()

func fix_rotation():
	var newRotation = Vector2.RIGHT.angle_to(linear_velocity)
	$Node2D.global_rotation = newRotation

func _on_ProjectilePlayer_body_entered(body):
	if body.is_class("TileMap"):
		queue_free()
	if body.has_method("collided_with_slimeBall"):
		body.collided_with_slimeBall(self)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
