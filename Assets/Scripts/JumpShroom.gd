extends StaticBody2D

export var bounceForce = 900

func _on_Bouncer_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.stop()
		body.bounce_on_shroom(bounceForce)
		$AnimationPlayer.play("bounce")
#		$Node._shake($Sprite, 1, 5, 2)
