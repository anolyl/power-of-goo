extends BaseState

var retreatTimer = Timer.new()

func _ready():
	add_child(retreatTimer)
	retreatTimer.wait_time = 1
	retreatTimer.one_shot = true

func enter():
	retreatTimer.start()
	enemy.update_animation("grab")

func physics_process(delta):
	enemy.retreat(delta)
	enemy.move(enemy.get_velocity().normalized())
	if retreatTimer.time_left <= 0:
		return State.SEARCH
	
	return State.NULL
