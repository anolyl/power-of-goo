extends BaseState

var timer = Timer.new()
var chargeDirection

func _ready():
	add_child(timer)
	timer.wait_time = .5
	timer.one_shot = true

func enter():
	timer.start()
	enemy.update_animation("attack")


func physics_process(_delta):
	chargeDirection = enemy.get_velocity()
	enemy.charge(chargeDirection.normalized())
	if timer.time_left <= 0:
		return State.RETREAT
	
	return State.NULL
