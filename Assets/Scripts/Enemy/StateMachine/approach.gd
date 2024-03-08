extends BaseState

var target

var chargeTimer = Timer.new()

func _ready():
	add_child(chargeTimer)
	chargeTimer.wait_time = 1
	chargeTimer.one_shot = true

func enter():
	target = enemy.get_target()
	chargeTimer.start()
	enemy.update_animation("attack")

func exit():
	target = null

func physics_process(_delta):
	if chargeTimer.time_left <= 0:
		return State.CHARGE
	
	if enemy.has_target():
		enemy.move((target.global_position - enemy.global_position).normalized())
		return State.NULL
	
	return State.SEARCH
