extends BaseStateBoss1

func enter():
	userEntity.update_animation("move")
	userEntity.reset_velocity()

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(_delta):
	if userEntity.get_target() != null:
		return State.ROAM
	return State.NULL
