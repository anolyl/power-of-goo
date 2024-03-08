class_name PLR_SLIDE_STATE
extends PLAYER_BASE_STATE

var puddlingFor = 0
var waitToFall = 0

var cooldownRunning

func enter():
	.enter()
	player.collision_mask = player.collision_mask & 0b1000001
	
	cooldownRunning = false
	if not $PuddleCooldown.is_stopped():
		cooldownRunning = true

func exit():
	.exit()
	player.collision_mask = player.collision_mask | 0b1011001
	if not cooldownRunning:
		$PuddleCooldown.start()

func input(event):
	if event.is_action_pressed("jump"):
		if !checkIfFreeAbove():
			return

		player.velocity.y = -player.jumpForce
		return State.JUMP

	return null

func physics_process(delta):
	if cooldownRunning:
		return State.MOVE
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	var input_vector = receive_InputEvent()

	puddlingFor += delta

	if input_vector != 0:
		if player.is_on_floor():
			player.velocity.x = clamp(player.velocity.x + input_vector * player.puddleAcceleration * delta, -player.puddleMaxSpeed, player.puddleMaxSpeed)
	else:
		player.velocity.x = 0

	if puddlingFor >= player.puddleMaxDuration:
		if checkIfFreeAbove():
			puddlingFor = 0
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				return State.MOVE
			else:
				return State.IDLE
		else:
			puddlingFor = 0
			player.velocity.x = 0

	if !player.is_on_floor():
		waitToFall += delta
		if waitToFall > 0.2:
			puddlingFor = 0
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

func getRaycasts():
	return player.get_node("Raycasts").get_children()

func checkIfFreeAbove():
	var raycasts = getRaycasts()
	for raycast in raycasts:
		if raycast.is_colliding():
			return false
	return true
