extends RigidBody2D

signal has_been_removed

var isFalling

func _ready():
	isFalling = false
	gravity_scale = 0

func _process(delta):
	if position.y >= 5000:
		emit_signal("has_been_removed")
		queue_free()

func drop():
	add_central_force(Vector2(0, 500))
	isFalling = true


func _on_Stalactite_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(1, self)
		hide()
		yield(get_tree().create_timer(.2), "timeout")
		emit_signal("has_been_removed")
		queue_free()
