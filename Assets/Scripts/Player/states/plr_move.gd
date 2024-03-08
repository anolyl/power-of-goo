class_name PLR_MOVE_STATE
extends PLAYER_BASE_STATE

var waitToFall = 0

func enter():
	.enter()
	player.velocity.x = 0

func input(event):
	if event.is_action_pressed("jump"):
		player.play_sound("jump")
		player.velocity.y = -player.jumpForce
		return State.JUMP

	if event.is_action_pressed("Puddle") and UnlockedSkills.is_ability_unlocked("puddle"):
		return State.SLIDE

	return null

func physics_process(delta):
	var input_vector = receive_InputEvent()

	player.velocity.y += player.gravity * delta
	
	if player.can_play_walk():
		player.play_sound("walk")

	if Input.is_action_just_pressed("melee"): 
		player.get_node("MeleeAttack").hit((player.get_global_mouse_position() - player.global_position).normalized())

	if input_vector != 0:
		if player.is_on_floor():
			player.velocity.x = clamp(player.velocity.x + input_vector * player.acceleration * delta, - player.maxSpeed, player.maxSpeed)
		else:
			player.velocity.x = clamp(player.velocity.x + input_vector * player.accelerationAir * delta, - player.maxSpeed, player.maxSpeed)

	player.velocity.x = player.move_and_slide(player.velocity, Vector2.UP, true).x

	if input_vector == 0:
		return State.IDLE

	if !player.is_on_floor():
		waitToFall += delta
		if waitToFall > 0.2:
			return State.FALL
	else:
		waitToFall = 0
	return null

func receive_InputEvent():
	if Input.is_action_pressed("left"):
		return -1
	if Input.is_action_pressed("right"):
		return 1

	return 0
