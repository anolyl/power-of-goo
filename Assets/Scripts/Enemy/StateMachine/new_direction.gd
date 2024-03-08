extends BaseState

func enter():
	if randi() < (enemy.global_position - enemy.get_spawnPoint()).length() / 300:
		enemy.set_velocity((enemy.get_spawnPoint() - enemy.global_position).normalized())
	else:
		enemy.set_velocity(Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized())
	

func physics_process(_delta):
	if enemy.has_target():
		enemy.stop_passiveState_timer()
		return State.APPROACH
	
	return State.NULL
