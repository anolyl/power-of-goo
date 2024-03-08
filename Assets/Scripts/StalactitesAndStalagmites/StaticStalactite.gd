extends StaticBody2D

export var knockBackForce = 2.0

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(1, self, knockBackForce)
