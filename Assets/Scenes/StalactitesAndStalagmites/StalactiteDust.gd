extends RigidBody2D

func _ready():
	position.x += rand_range(-5, 5)

func _on_StalactiteDust_body_entered(body):
	queue_free()
