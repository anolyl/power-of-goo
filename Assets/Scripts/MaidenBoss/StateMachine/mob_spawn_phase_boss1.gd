extends BaseStateBoss1

var spawnTimer = Timer.new()
var spawnCounter

var chargeStart

func _ready():
	add_child(spawnTimer)
	
	spawnTimer.wait_time = 3
	
	spawnTimer.connect("timeout", self, "_on_spawnTimer_timeout")

func enter():
	chargeStart = userEntity.get_chargeStart_location()
	spawnCounter = 0
	spawnTimer.start()
	userEntity.update_animation("giveBirth")
	userEntity.emit_birth_process(true)

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(_delta):
	if spawnCounter >= 3:
		return State.IDLE
	
	if userEntity.global_position.distance_to(chargeStart) > 100:
		userEntity.move_to_chargeStart_location()
	return State.NULL

func _on_spawnTimer_timeout():
	if spawnCounter < 3:
		for i in range(0, 3):
			userEntity.spawn_maiden_child()
		userEntity.emit_birth_explode()
		if spawnCounter == 2:
			userEntity.update_animation("idle")
			userEntity.emit_birth_process(false)
		spawnCounter += 1
	else:
		userEntity.next_phase()
