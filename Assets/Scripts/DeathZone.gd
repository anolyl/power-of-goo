extends Area2D



func _on_DeathZone_body_entered(body):
#	print("Player entered Deathzone")
	if body.has_method("take_damage"):
		body.take_damage(1)
		body.global_position = $RespawnPosition.global_position
