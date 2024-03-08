extends BaseState

var lastPosition

func enter():
	lastPosition = enemy.get_last_known_target_position()
	enemy.update_animation("attack")

func exit():
	pass

func physics_process(_delta):
	if enemy.has_target():
		return State.APPROACH
	
	if lastPosition:
		enemy.move((lastPosition - enemy.global_position).normalized())
	else:
		return State.IDLE

	if (lastPosition - enemy.global_position).length() < 50:
		return State.IDLE
	
	return State.NULL
