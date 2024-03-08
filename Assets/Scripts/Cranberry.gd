extends RigidBody2D

export (float) var healAmount = 1.0
export (PackedScene) var cranberryPickupEffect

func _on_Cranberry_body_entered(body):
	if body.has_method("heal"):
		body.heal(healAmount)
		destroy_on_interaction()

func destroy_on_interaction():
	if cranberryPickupEffect:
		var clone = cranberryPickupEffect.instance()
		get_parent().add_child(clone)
		clone.global_position = global_position
	queue_free()
