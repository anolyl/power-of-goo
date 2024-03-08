extends Node

onready var states = {
	PLAYER_BASE_STATE.State.IDLE: $idle,
	PLAYER_BASE_STATE.State.MOVE: $move,
	PLAYER_BASE_STATE.State.JUMP: $jump,
	PLAYER_BASE_STATE.State.FALL: $fall,
	PLAYER_BASE_STATE.State.SLIDE: $slide
}

var currentState

func change_state(new_state):
	if currentState:
		currentState.exit()

	currentState = states[new_state]
	currentState.enter()

func init(player):
	for child in get_children():
		child.player = player

	change_state(PLAYER_BASE_STATE.State.IDLE)

func physics_process(delta):
	var new_state = currentState.physics_process(delta)
	if new_state != null:
		change_state(new_state)

func input(event):
	var new_state = currentState.input(event)
	if new_state != null:
		change_state(new_state)

func process(delta):
	var new_state = currentState.process(delta)
	if new_state != null:
		change_state(new_state)

func getState():
	return currentState
