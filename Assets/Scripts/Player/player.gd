class_name Player
extends KinematicBody2D

signal hasDied

#Exported Libraries
export (PackedScene) var spitProjectileTemplate

#Movement related
export var maxSpeed = 300
export var acceleration = 20000
export var accelerationAir = 300
export var frictionAir = 100
export var frictionFloor = 20000
export var gravity = 1000
export var jumpForce = 600
export var puddleMaxSpeed = 300
export var puddleAcceleration = 10000
export var puddleMaxDuration = 2
export var maxDoubleJumps = 1
export var doubleJumpDamping = 200

onready var velocity = Vector2.ZERO
onready var animations = $AnimationPlayer
onready var states = $player_states
onready var projectileParent
onready var canSpit = true
onready var extraJumpCount = 1
onready var health = 4
onready var cranberryAmount = 0
onready var slimesRescued = 0
onready var currentLevel
onready var currentCheckpoint

#TODO: Change this!!!!!!!!! Quick and dirty solution for playing walk-sound properly
var canPlayWalkSound = true

func _ready():  
	states.init(self)
	$MeleeAttack.setup(self)
	var root = get_tree().get_root()
	var main = root.get_node("main")
	var libraries = main.get_node("Libraries")
	var saveManager = libraries.get_node("saveManager")
	
	currentLevel = self.get_parent().name

	var data = saveManager.load_game()
	var playerVars = data.player

	setHealthAmt(playerVars.health)
	setCranberryAmt(playerVars.cranberries)
	slimesRescued = data.slimesRescued
	$HUD/cageHUD/Label.text = str(slimesRescued)

func takeHealthAmt(amt):
	health -= amt
	$HUD/healthBar.setHealth(health)

func setHealthAmt(amt=null):
	if amt:
		health = amt
	$HUD/healthBar.setHealth(health)

func takeCranberryAmt(amt):
	cranberryAmount -= amt
	$HUD/cranberryHUD.setCranberryAmount(cranberryAmount)

func setCranberryAmt(amt=null):
	if amt:
		cranberryAmount = amt
	$HUD/cranberryHUD.setCranberryAmount(cranberryAmount)

func addSlimesRescued():
	slimesRescued += 1
	$HUD/cageHUD.setResecuedAmount(slimesRescued)

func _unhandled_input(event):
	states.input(event)

func _physics_process(delta):
	states.physics_process(delta)
	
	shoot_slime()

	if Input.is_action_just_pressed("cranberryUse"):
		if cranberryAmount > 0 and health < 4:
			takeCranberryAmt(1)
			setHealthAmt(health + 1)
			
			play_sound("cranberryEat")

	var slideCount = get_slide_count()
	if slideCount:
		isSloping(slideCount)
	
	if velocity.x > 1:
		$Sprite.flip_h = false
	elif velocity.x < -1:
		$Sprite.flip_h = true

func _process(delta):
	states.process(delta)

func isSloping(slides):
	for i in slides:
		var sliding = get_slide_collision(i)
		if is_on_floor() and sliding.normal.y < 0.5 and velocity.x != 0:
			velocity.y = sliding.normal.y

func take_damage(amt, source = null, knockbackForce = 1):
	play_sound("pain")
	$Libraries/shaker._shake($Camera2D, 7.5, 7.15, 0.4)
	knock_back(source, knockbackForce)
	takeHealthAmt(amt)

	if health <= 0:
		die()

func heal(amt):
	setCranberryAmt(cranberryAmount + amt)

func knock_back(source, knockbackForce):
	if source:
		velocity = 0
		velocity = (source.global_position.direction_to(global_position) + Vector2(0, -3)).normalized() * maxSpeed * 2 * knockbackForce
	pass

func bounce_on_shroom(force):
	velocity.y = -force

func shoot_slime():
	if Input.is_action_just_pressed("shoot"):
		if !canSpit: 
			return

		canSpit = false
		$SpitCooldown.start()
		$RadialBar.takeBars()
		var newSlime = spitProjectileTemplate.instance()
		newSlime.setup(get_global_mouse_position() - $Muzzle.global_position)
		
		projectileParent.add_child(newSlime)
		newSlime.global_position = $Muzzle.global_position
		play_sound("spit")

func setup_projectileParent(projectileParentIN):
	projectileParent = projectileParentIN

func _on_SpitCooldown_timeout():
	canSpit = true

func die():
	emit_signal("hasDied")

func play_sound(sound):
	match sound:
		"walk": 
			$AudioPlayer.play_walk()
			$AnimationPlayer.playback_speed = 1.25
			canPlayWalkSound = false
		"pain": $AudioPlayer.play_pain()
		"spit": $AudioPlayer.play_spit()
		"jump": $AudioPlayer.play_jump()
		"landing": $AudioPlayer.play_landing()
		"swing": $AudioPlayer.play_swing()
		"swingHit": $AudioPlayer.play_swingHit()
		"cranberryEat": $AudioPlayer.play_cranberryEat()

func can_play_walk():
	return canPlayWalkSound

func _on_Walk_finished():
	canPlayWalkSound = true
	$AnimationPlayer.playback_speed = 1

func get_velocity():
	return velocity

func freeze():
	set_physics_process(false)
	velocity = Vector2.ZERO

func resume(velocityIN):
	set_physics_process(true)

func get_data():
	return {
		"health": health,
		"cranberries": cranberryAmount,
		"currentCheckpoint": currentCheckpoint,
		"currentScene": currentLevel
	}
	
