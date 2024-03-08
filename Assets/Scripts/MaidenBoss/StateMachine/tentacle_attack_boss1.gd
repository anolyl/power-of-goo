extends BaseStateBoss1

var attackTimer = Timer.new()

#TODO: Variablennamen ändern - Boss wartet zwei Timer ticks, ohne dass geschossen wird
var timerCounter
var exitState

func _ready():
	add_child(attackTimer)
	
	attackTimer.connect("timeout", self, "_on_attackTimer_timeout")

func enter():
	attackTimer.wait_time = userEntity.get_spike_attack_interval()
	exitState = false
	timerCounter = 0
	attackTimer.start()
	userEntity.update_animation("spikeAttackEnter")
	userEntity.queue_animation("spikeAttackProcess")

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(delta):
	if exitState:
		return State.IDLE
	
	userEntity.move_to_ceiling_center(delta)
	
	return State.NULL

func _on_attackTimer_timeout():
	var maxShots = userEntity.get_spike_amount()
	
	timerCounter += 1
	
	if timerCounter <= maxShots:
		userEntity.attack()
	
	if timerCounter > maxShots + 2:
		attackTimer.stop()
		userEntity.update_animation("spikeAttackExit")
		yield(get_tree().create_timer(1), "timeout")
		exitState = true
