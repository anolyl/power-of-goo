class_name PLR_JUMP_STATE
extends PLAYER_BASE_STATE 

func enter():
	.enter()

func input(event):
	if Input.is_action_just_pressed("jump") and UnlockedSkills.is_ability_unlocked("doubleJump"):
		if player.extraJumpCount < player.maxDoubleJumps + 1:
			player.velocity.y = -(player.jumpForce - player.doubleJumpDamping * player.extraJumpCount)
			player.extraJumpCount += 1

#			print("extra jump: ")
			return State.JUMP
		else:
			return null

	return null

func physics_process(delta):
	var move = 0

	if Input.is_action_pressed("left"):
		move = -1
	elif Input.is_action_pressed("right"):
		move = 1

	if Input.is_action_just_pressed("melee"): 
		player.get_node("MeleeAttack").hit((player.get_global_mouse_position() - player.global_position).normalized())

	player.velocity.x = move * player.maxSpeed
	player.velocity.y += player.gravity * delta

	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if player.velocity.y > 0:
		return State.FALL

	if player.is_on_floor():
		if move != 0:
			return State.MOVE
		else:
			return State.IDLE
	return null
