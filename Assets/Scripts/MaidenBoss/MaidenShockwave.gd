extends RigidBody2D

var spawnPosition

func setup(direction, speed, size, spawnPositionIN):
	if direction.x > 0:
		$Sprite.flip_h = true
		$TrailParticle.texture = load("res://Assets/Sprites/BossRooms/MaidenBossRoom/shockwaveFlipped.png")
	linear_velocity = direction * speed
	$CollisionShape2D.shape.extents.y = 24 + (size - 1) * 24
	$Sprite.scale *= size
	$Sprite.position.y -= (size - 1) * 24
	$CollisionShape2D.position.y = -24 - (size - 1) * 24
	
	spawnPosition = spawnPositionIN

func _ready():
	global_position = Vector2(spawnPosition.x, -27)

func _on_MaidenShockwave_body_entered(body):
	if body.is_in_group("Player"):
		set_deferred("contact_monitor", false)
		$CollisionShape2D.set_deferred("disabled", true)
		angular_velocity = 0
		$Sprite.hide()
		body.take_damage(1, self)
		$TrailParticle.emitting = false

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.playing = false
