class_name PLR_FALL_STATE
extends PLAYER_BASE_STATE

onready var extraJumpCount = 1

func enter():
	.enter()
	player.velocity.x = 0

func input(event):
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return null
	if Input.is_action_just_pressed("jump") and UnlockedSkills.is_ability_unlocked("doubleJump"):
		if player.extraJumpCount < player.maxDoubleJumps + 1:
			player.velocity.y = -(player.jumpForce - player.doubleJumpDamping * player.extraJumpCount)
			player.extraJumpCount += 1
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

	player.velocity.x = move * player.maxSpeed
	player.velocity.y += player.gravity * delta

	player.velocity = player.move_and_slide(player.velocity, Vector2.UP, false)
	
	if Input.is_action_just_pressed("melee"): 
		player.get_node("MeleeAttack").hit((player.get_global_mouse_position() - player.global_position).normalized())
	
	if player.global_position.y > 3000:
		get_tree().reload_current_scene()

	if player.is_on_floor():
		player.extraJumpCount = 1
		
		player.play_sound("landing")
		if move != 0:
			return State.MOVE
		else:
			return State.IDLE
	return null
