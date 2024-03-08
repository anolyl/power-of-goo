extends BaseState

var slimedTimer = Timer.new()

func _ready():
	add_child(slimedTimer)
	slimedTimer.wait_time = 4
	slimedTimer.one_shot = true

func enter():
	slimedTimer.start()
	get_slimed()
	enemy.update_animation("hit")

func exit():
	slimedTimer.stop()
	stop_slimed()

func physics_process(_delta):
	if slimedTimer.time_left <= 0:
		return State.IDLE
	
	return State.NULL

func get_slimed():
	enemy.show_slimed_particles()

func stop_slimed():
	enemy.hide_slimed_particles()
