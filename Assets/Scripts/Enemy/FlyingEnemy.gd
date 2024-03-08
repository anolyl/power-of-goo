extends KinematicBody2D

signal hasDied

onready var sprite = $Sprite
onready var states = $state_manager

export var speed = 100
export var chargeSpeed = 300
export var retreatAccel = 150
var velocity = Vector2()

var isSlimed
var target
var targetLastKnownPosition
var targetIsVisible
var hitPos
var spawnPosition

func _ready():
	randomize()
	isSlimed = false
	spawnPosition = global_position
	states.init(self)
	
	var rayDirection = Vector2(0, 50)
	
	for child in $Rays.get_children():
		child.cast_to = rayDirection
		child.enabled = true
		rayDirection = rayDirection.rotated(PI / 4)
	
	targetIsVisible = false

func _physics_process(delta):
	#update()
	update_face_direction()
	get_rays_feedback()
	if target:
		aim()
	states.physics_process(delta)
	

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position, [self], collision_mask)
	if result:
		hitPos = result.position
		if result.collider.is_in_group("Player"):
			targetIsVisible = true
		else:
			targetIsVisible = false

func _draw():
#	for child in $Rays.get_children():
#		draw_line(Vector2(), child.cast_to, Color(1, 0, 0))
	
	if target and hitPos:
		draw_circle(hitPos - position, 5, Color(1, 0, 0))
		draw_line(Vector2(), hitPos - position, Color(1, 0, 0))

func get_rays_feedback():
	pass

func flash():
	sprite.material.set_shader_param("flash_modifier", 1)
	$FlashTimer.start()

func _on_FlashTimer_timeout():
	var current_modifier = sprite.material.get_shader_param("flash_modifier")
	sprite.material.set_shader_param("flash_modifier", current_modifier - .1)
	if not current_modifier - .1 <= 0:
		$FlashTimer.start()


func collided_with_slimeBall(slimeBall):
	isSlimed = true
	states.collided_with_slimeBall()
	flash()
	$AudioPlayer/SlimeballHit.play()
	slimeBall.queue_free()

func collided_with_playerAttack():
	if states.current_state == states.states[BaseState.State.SLIMED]:
		var root = get_tree().get_root()
		var main = root.get_node("main")
		var libraries = main.get_node("Libraries")
		var saveManager = libraries.get_node("saveManager")

		var currentLevelHolder = main.get_node("CurrentLevel")
		var currentLevel = currentLevelHolder.get_children()[0]

		saveManager.append_to_be_destroyed(currentLevel, self)
		emit_signal("hasDied", global_position)
		queue_free()


func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		target = body


func _on_Detection_body_exited(body):
	if body == target and not isSlimed:
		targetLastKnownPosition = target.global_position
		target = null
		targetIsVisible = false


func _on_Hitbox_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(1, self)


func impact_pause(time):
	set_physics_process(false)
	$ImpactTimer.wait_time = time
	$ImpactTimer.start()

func _on_ImpactTimer_timeout():
	set_physics_process(true)

func avoid_wall():
	for child in $Rays.get_children():
		if child.get_collider():
			velocity = velocity.linear_interpolate(velocity - child.cast_to, .3)

func update_face_direction():
	if velocity.x > 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

#==================================================================
#STATE MACHINE FUNCTIONS
#==================================================================

func move(dir):
	velocity = velocity.linear_interpolate(dir * speed, .1)
	avoid_wall()
	
	velocity = move_and_slide(velocity)

func charge(dir):
	velocity = dir * chargeSpeed
	if target:
		velocity = velocity.linear_interpolate(global_position.direction_to(target.global_position) * chargeSpeed, .05)
	
	velocity = move_and_slide(velocity)

func retreat(delta):
	velocity = velocity.linear_interpolate(Vector2.UP * chargeSpeed, delta)

func has_target():
	if targetIsVisible:
		return true
	return false

func get_spawnPoint():
	return spawnPosition

func set_velocity(dir):
	velocity = dir * speed

func get_velocity():
	return velocity

func stop_passiveState_timer():
	$PassiveStateChange.stop()

func start_passiveState_timer():
	$PassiveStateChange.start()

func _on_PassiveStateChange_timeout():
	$PassiveStateChange.wait_time = rand_range(.75, 1.5)
	states.passive_state_change()

func get_target():
	return target

func show_slimed_particles():
	$SlimedParticle.show()
	$PassiveStateChange.stop()
	$GetSlimedParticle.emitting = true
	$GetSlimedParticleOuter.emitting = true


func hide_slimed_particles():
	$SlimedParticle.hide()
	isSlimed = false

func get_last_known_target_position():
	return targetLastKnownPosition

func update_animation(animation):
	$Sprite.play(animation)
