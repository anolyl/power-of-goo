extends BaseStateBoss1

onready var timer = Timer.new()
var roamCounter

func _ready():
	randomize()
	add_child(timer)
	timer.wait_time = rand_range(3, 5)
	timer.one_shot = true

func enter():
	timer.start()
	roamCounter = rand_range(-1, 1)

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(delta):
	roamCounter += .02
	if timer.time_left <= 0:
		if userEntity.get_phase() == 2:
			return State.MOB_SPAWN_PHASE
		
		if randf() <= .65:
			return State.CHARGE
		else:
			return State.TENTACLE_ATTACK
	userEntity.roam(delta, roamCounter)
	
	return State.NULL
