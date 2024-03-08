extends RigidBody2D

export var speed = 800

#TODO: Random Verzug als regelbare Variable im StationaryEnemy-Skript einfügen
func setup(dir):
	linear_velocity = dir.normalized() * speed
	$Bubbling.pitch_scale = rand_range(1, 1.3)

func _process(_delta):
	fix_rotation()

func fix_rotation():
	var newRotation = Vector2.RIGHT.angle_to(linear_velocity)
	$Node2D.global_rotation = newRotation

func _on_ProjectileEnemy_body_entered(body):
	if body.is_class("TileMap"):
		queue_free()
	if body.is_in_group("Player"):
		body.take_damage(1, self)
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
