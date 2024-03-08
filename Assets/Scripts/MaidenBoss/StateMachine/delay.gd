extends BaseStateBoss1

var timer = Timer.new()
var exitState

func _ready():
	add_child(timer)
	timer.wait_time = .75
	timer.one_shot = true
	
	timer.connect("timeout", self, "_on_timer_timeout")

func enter():
	exitState = false
	timer.start()

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(_delta):
	if exitState:
		return State.IDLE
	
	return State.NULL

func _on_timer_timeout():
	exitState = true
