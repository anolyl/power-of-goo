extends BaseState

func enter():
	pass

func physics_process(_delta):
	if enemy.has_target():
		enemy.stop_passiveState_timer()
		return State.APPROACH
	
	enemy.move(enemy.get_velocity().normalized())
	
	return State.NULL
