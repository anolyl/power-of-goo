extends PLAYER_BASE_STATE

var waitToFall = 0

func enter():
	.enter()
	player.velocity.x = 0

func input(event):
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return State.MOVE
	elif Input.is_action_just_pressed("jump"):
		player.velocity.y = -player.jumpForce
		player.play_sound("jump")
		return State.JUMP
	elif event.is_action_pressed("Puddle") and UnlockedSkills.is_ability_unlocked("puddle"):
		return State.SLIDE

	return null

func physics_process(delta):
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP, true)

	player.velocity.y += player.gravity * delta

	if Input.is_action_just_pressed("melee"): 
		player.get_node("MeleeAttack").hit((player.get_global_mouse_position() - player.global_position).normalized())

	if !player.is_on_floor():
		waitToFall += delta
		if waitToFall > 0.2:
			return State.FALL
	else:
		waitToFall = 0
	return null
