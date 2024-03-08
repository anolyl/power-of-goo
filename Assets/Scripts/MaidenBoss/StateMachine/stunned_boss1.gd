extends BaseStateBoss1

var hasBeenHit

var timer = Timer.new()

func _ready():
	add_child(timer)
	timer.one_shot = true

func enter():
	timer.wait_time = 4
	hasBeenHit = false
	timer.start()

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(_delta):
	if timer.time_left <= 0:
		return State.IDLE
	
	return State.NULL

func on_hit():
	if hasBeenHit:
		return
	hasBeenHit = true
	userEntity.update_animation("hit")
	timer.stop()
	timer.wait_time = .5
	timer.start()
