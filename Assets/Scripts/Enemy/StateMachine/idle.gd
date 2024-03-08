extends BaseState

func enter():
	enemy.start_passiveState_timer()
	enemy.update_animation("idle")

func physics_process(_delta):
	if enemy.has_target():
		enemy.stop_passiveState_timer()
		return State.APPROACH
	
	
	return State.NULL
