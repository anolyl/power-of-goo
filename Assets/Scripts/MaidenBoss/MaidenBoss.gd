extends KinematicBody2D

signal hitGround
signal hasBeenHit
signal hasDied

export (PackedScene) var spikeTemplate
export (PackedScene) var shockwaveTemplate
export (PackedScene) var maidenTemplate

export var spikeSpeed = 1000
export var spikeAttackInterval = 1.5
export var spikeLifeTime = 2.5
export var spikeAmount = 10

var projectileParent
var enemyParent
var chargeStart
var chargeStart1
var chargeStart2
var roamCenter
var target

var currentDelta

var health
const MAX_HEALTH = 4

var velocity = Vector2()
var acceleration = 1000
var maxSpeed = 300

var isSlimed
var phase

var animationQueue = []

var scream1 = preload("res://Assets/MusicAndSounds/MotherMaiden/Scream01.wav")
var scream2 = preload("res://Assets/MusicAndSounds/MotherMaiden/Scream02.wav")
var scream3 = preload("res://Assets/MusicAndSounds/MotherMaiden/Scream03.wav")
var screams = [scream1, scream2, scream3]

onready var states = $state_manager_boss1
onready var sprite = $AnimatedSprite

func setup(projectileParentIN, enemyParentIN, targetIN, chargeStart1IN, chargeStart2IN, roamCenterIN):
	if projectileParentIN:
		projectileParent = projectileParentIN
	else:
		projectileParent = owner
	
	if enemyParentIN:
		enemyParent = enemyParentIN
	else:
		enemyParent = owner
	
	if chargeStart1IN:
		chargeStart1 = chargeStart1IN
	else:
		chargeStart1 = Vector2()
	
	if chargeStart2IN:
		chargeStart2 = chargeStart2IN
	else:
		chargeStart2 = chargeStart1
	
	if roamCenterIN:
		roamCenter = roamCenterIN
	else:
		roamCenter = Vector2()
	
	target = targetIN

func _ready():
	randomize()
	isSlimed = false
	states.init(self)
	health = MAX_HEALTH
	phase = 1

func _physics_process(delta):
	currentDelta = delta
	states.physics_process(delta)
	update_face_direction()

func update_face_direction():
	if target:
		if target.global_position.x <= global_position.x:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

func collided_with_slimeBall(projectile):
	if states.check_if_charging():
		flash()
	projectile.queue_free()

func collided_with_playerAttack():
	if states.check_if_stunned():
		emit_signal("hitGround", true)
		emit_signal("hasBeenHit", global_position)
		flash()
		states.has_been_hit()
		health -= 1
		if health < MAX_HEALTH / 2.0:
			next_phase()
		if health <= 0:
			emit_signal("hasDied", Vector2(), true)
			queue_free()
		

func flash():
	sprite.material.set_shader_param("flash_modifier", 1)
	$FlashTimer.start()

func _on_FlashTimer_timeout():
	var current_modifier = sprite.material.get_shader_param("flash_modifier")
	sprite.material.set_shader_param("flash_modifier", current_modifier - .1)
	if not current_modifier - .1 <= 0:
		$FlashTimer.start()

#=======================================================
#STATE MACHINE FUNCTIONS
#=======================================================

func get_target():
	return target

func roam(_delta, roamCounter):
	var roamPosition = Vector2()
	roamPosition.x = roamCenter.global_position.x + 500 * cos(roamCounter)
	roamPosition.y = roamCenter.global_position.y + 250 * sin(2 * roamCounter) / 2
	
	velocity = global_position.direction_to(roamPosition) * maxSpeed
	velocity = move_and_slide(velocity)

func get_distance_to_target():
	return (target.global_position - global_position).length()

func move_to_ceiling_center(delta):
	if global_position.distance_to(roamCenter.global_position) > 100:
			velocity += global_position.direction_to(roamCenter.global_position) * acceleration * 2 * delta
			velocity = velocity.limit_length(maxSpeed * 1.5)
			
			velocity = move_and_slide(velocity)
	else:
		velocity = velocity.linear_interpolate(Vector2.ZERO, .9)

func attack():
	var newSpike = spikeTemplate.instance()
	
	var direction
	
	if randf() < .25:
		direction = global_position.direction_to(target.global_position)
		newSpike.setup(direction, spikeLifeTime, spikeSpeed)
	else:
		direction = Vector2(rand_range(-1, 1), rand_range(0, 1)).normalized()
		newSpike.setup(direction, spikeLifeTime, spikeSpeed)
	
	newSpike.global_position = global_position + Vector2(0, -39)
	
	projectileParent.add_child(newSpike)
	play_tentacle_sound()

func change_collision(value):
	collision_mask = value

func charge_and_collide(direction, delta):
	var speedMultiplier = 3
	if health < MAX_HEALTH / 2.0:
		speedMultiplier = 5
	
	velocity = direction * maxSpeed * speedMultiplier
	
	return move_and_collide(velocity * delta)

func get_chargeStart_location():
	if randf() < .5:
		chargeStart = chargeStart1
		return chargeStart1.global_position
	else:
		chargeStart = chargeStart2
		return chargeStart2.global_position

func move_to_chargeStart_location():
	velocity = global_position.direction_to(chargeStart.global_position) * maxSpeed * 2
	
	velocity = move_and_slide(velocity)

func hit_ground():
	emit_signal("hitGround", false)
	$ImpactParticles.process_material.initial_velocity = 1000
	shockwave()

func shockwave():
	var amplifier = 1
	var speed = 300
	var size = 1
	
	if health < MAX_HEALTH / 2.0:
		amplifier = 2
	
	var newShockwave1 = shockwaveTemplate.instance()
	
	newShockwave1.setup(Vector2.LEFT, speed * amplifier, size * amplifier, global_position)
	projectileParent.add_child(newShockwave1)
	
	var newShockwave2 = shockwaveTemplate.instance()
	
	newShockwave2.setup(Vector2.RIGHT, speed * amplifier, size * amplifier, global_position)
	projectileParent.add_child(newShockwave2)


func emit_charge_particles():
	$ImpactParticles.process_material.initial_velocity = 0
	$ImpactParticles.emitting = true

func emit_trail():
	$Trail.emitting = true

func seize_trail_emit():
	$Trail.emitting = false

func _on_Hitbox_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(2, self)

func update_animation(animation, reverse = false):
	sprite.stop()
	sprite.play(animation, reverse)
	
	var lastFrame = sprite.frames.get_frame_count(animation) - 1
	sprite.frame = lastFrame if reverse else 0

func queue_animation(animation):
	animationQueue.append(animation)

func _on_AnimatedSprite_animation_finished():
	if animationQueue.size() > 0:
		sprite.play(animationQueue.front())
		animationQueue.pop_front()

func reset_velocity():
	velocity = Vector2()

func get_phase():
	return phase

func next_phase():
	phase += 1

func spawn_maiden_child():
	var newMaidenChild = maidenTemplate.instance()
	newMaidenChild.global_position = global_position + Vector2(rand_range(-35, 35), rand_range(-35, 35))
	
	enemyParent.add_child(newMaidenChild)
	newMaidenChild.connect("hasDied", get_tree().root.get_child(3), "_on_enemy_has_died")

func get_spike_amount():
	return spikeAmount

func get_spike_attack_interval():
	return spikeAttackInterval

func get_sprite():
	return $AnimatedSprite

func emit_birth_process(cond):
	$BirthProcess.emitting = cond

func emit_birth_explode():
	$BirthExplode.restart()
	$BirthExplode.emitting = true

func play_scream_sound():
	screams.shuffle()
	$Scream.stream = screams.front()
	$Scream.play()

func play_hitWall_sound():
	$Hitwall.play()

func play_tentacle_sound():
	$TentacleAttack.pitch_scale = rand_range(1, 1.5)
	$TentacleAttack.play()

func play_laugh_sound():
	$EvilLaugh.pitch_scale = rand_range(.8, 1.2)
	$EvilLaugh.play()
