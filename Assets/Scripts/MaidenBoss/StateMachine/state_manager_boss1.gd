extends Node

onready var states = {
	BaseStateBoss1.State.START: $start,
	BaseStateBoss1.State.IDLE: $idle,
	BaseStateBoss1.State.ROAM: $roam,
	BaseStateBoss1.State.TENTACLE_ATTACK: $tentacle_attack,
	BaseStateBoss1.State.CHARGE: $charge,
	BaseStateBoss1.State.STUNNED: $stunned,
	BaseStateBoss1.State.DELAY: $delay,
	BaseStateBoss1.State.MOB_SPAWN_PHASE: $mob_spawn_phase
}

var current_state

func change_state(new_state):
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	current_state.enter()


func init(userEntity):
	for child in get_children():
		child.userEntity = userEntity
	
	change_state(BaseStateBoss1.State.START)

func physics_process(delta):
	var new_state = current_state.physics_process(delta)
	if new_state != BaseStateBoss1.State.NULL:
		change_state(new_state)

func check_if_charging():
	if current_state == states[BaseStateBoss1.State.CHARGE]:
		current_state.slimed = true
		return true

func check_if_stunned():
	if current_state == states[BaseStateBoss1.State.STUNNED]:
		return true
	

func has_been_hit():
	current_state.on_hit()
