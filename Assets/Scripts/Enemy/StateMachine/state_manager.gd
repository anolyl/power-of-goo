extends Node

onready var states = {
	BaseState.State.IDLE: $idle,
	BaseState.State.NEW_DIRECTION: $new_direction,
	BaseState.State.PATROL: $patrol,
	BaseState.State.APPROACH: $approach,
	BaseState.State.CHARGE: $charge,
	BaseState.State.RETREAT: $retreat,
	BaseState.State.SEARCH: $search,
	BaseState.State.SLIMED: $slimed
}

var current_state

func change_state(new_state):
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	current_state.enter()


func init(enemy):
	for child in get_children():
		child.enemy = enemy
	
	change_state(BaseState.State.IDLE)

func physics_process(delta):
	var new_state = current_state.physics_process(delta)
	if new_state != BaseState.State.NULL:
		change_state(new_state)

func passive_state_change():
	var array = [BaseState.State.IDLE, BaseState.State.NEW_DIRECTION, BaseState.State.PATROL]
	array.shuffle()
	change_state(array.front())

func collided_with_slimeBall():
	change_state(BaseState.State.SLIMED)
