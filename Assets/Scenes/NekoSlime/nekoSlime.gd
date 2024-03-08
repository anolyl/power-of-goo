extends KinematicBody2D

signal openChest

export (int) var state
export (PackedScene) var projectileTemplate
export (bool) var isPunching

var leavesScene
var hasShot

var tooltips = ["Press [SPACE] to jump", #1
"Press [RMB] to use your spit ability to stun enemies", #2
"Press [LMB] to use your punch", #3
"Use your punch to free your fellow slimes from cages", #4
"Press [Q] to eat a cranberry and restore your HP", #5
"You feel empowered. A tingling sensation flows through your fist.", #6
"", #7
"The lid of the chest won't budge.", #8
"The lid of the chest won't budge.", #9
"", #10
"Press [SHIFT] to turn into a slime-puddle in order to fit into tighter spaces", #11
"Press [SPACE] while in the air to perform a double-jump", #12
]

var speed = 300
var gravity = 2500
var jumpForce = 795
var velocity = Vector2()

var lastDelta

func _ready():
	leavesScene = false
	hasShot = false
	isPunching = false
	set_physics_process(false)
	update_tooltip()
	new_dialogue()
	if state == 8:
		$Sprite.hide()
		if UnlockedSkills.is_ability_unlocked("hasKey"):
			#if hasKey -> state = 10
			next_state()
			next_state()

func _physics_process(delta):
	lastDelta = delta
	$Sprite.flip_h = false
	gravity()
	if state == 1:
		move1()
		jump1()
	
	if state == 2:
		if not hasShot:
			move2()
		else:
			move1()
			jump1()
		check_for_enemies()
	
	if state == 3:
		move3()
		check_for_enemies()
	
	if state == 5:
		move2()
	
	if state == 7:
		move2()
	
	if velocity == Vector2(0, 0):
		update_animation("idle")

func _on_Dialogue_dialogueFinished():
	$AnimationPlayer.play("showTooltip")
	if state == 6:
		if not UnlockedSkills.is_ability_unlocked("strongPunch"):
			UnlockedSkills.unlock_ability("strongPunch")
			var root = get_tree().get_root()
			var main = root.get_node("main")
			var libraries = main.get_node("Libraries")
			var saveManager = libraries.get_node("saveManager")

			var currentLevelHolder = main.get_node("CurrentLevel")
			var currentLevel = currentLevelHolder.get_children()[0]

			saveManager.append_to_be_destroyed(currentLevel, self)
		
	if state == 8:
		$DialogueDetection.monitoring = false
		yield(get_tree().create_timer(2), "timeout")
		$DialogueDetection.monitoring = true
		next_state()
	
	if state == 11:
		if not UnlockedSkills.is_ability_unlocked("puddle"):
			UnlockedSkills.unlock_ability("puddle")
	
	if state == 10:
		$Chest/AnimatedSprite.play("default")
		$DialogueDetection.monitoring = false
		yield($Chest/AnimatedSprite, "animation_finished")
		$DialogueDetection.monitoring = true
		$Sprite.show()
		next_state()
	
	if state == 12:
		if not UnlockedSkills.is_ability_unlocked("doubleJump"):
			UnlockedSkills.unlock_ability("doubleJump")
	
	set_physics_process(true)

#==================STATE 1=====================================

func move1():
	velocity.x = speed
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x <= 2:
		jump1()
	
	if is_on_floor():
		update_animation("walk")
	
	if not hasShot:
		check_for_next_state(position.x >= 1900)

func jump1():
	if len($GroundDetection1.get_overlapping_bodies()) == 0 and is_on_floor():
		update_animation("jump")
		velocity.y = - jumpForce

#======================STATE 2==================================

func move2():
	velocity.x = speed
	
	if not is_on_floor() or len($EnemyDetection2.get_overlapping_bodies()) != 0:
		if not hasShot:
			velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		update_animation("walk")
	
	if hasShot and velocity.x == 0:
		jump2()

func jump2():
	if is_on_floor():
		update_animation("jump")
		velocity.y = - jumpForce

#============================STATE 3==============================

func move3():
	velocity.x = speed
	
	if not is_on_floor() or len($EnemyDetection2.get_overlapping_bodies()) != 0:
		if not hasShot:
			velocity.x = 0
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if hasShot and velocity.x == 0:
		jump2()
	
	if is_on_floor() and not isPunching:
		update_animation("walk")
	
	check_for_next_state(position.x >= 2900)


#===============================STATE 4============================

func _on_SlimeCage_hasBeenBroken():
	if state == 4:
		$AnimationPlayer.play("RESET")
		$DelayedDialogueTimer.start()
		next_state()
	
	if state == 12:
		$Dialogue.start()

func _on_DelayedDialogueTimer_timeout():
	$DialogueDetection/NewDialogue.hide()
	$Dialogue.start()
#==================================================================

func check_for_enemies():
	if len($EnemyDetection2.get_overlapping_bodies()) > 0:
		shoot_at_enemy()

func shoot_at_enemy():
	
	if hasShot:
		return
	if not $HasShotTimer.is_stopped():
		return
	
	$HasShotTimer.start()
	
	update_animation("spit")
	
	var targetEnemy = $EnemyDetection2.get_overlapping_bodies().front()
	var newProjectile = projectileTemplate.instance()
	newProjectile.setup(global_position.direction_to(targetEnemy.global_position + Vector2(0, -50)), Color(0, 112, 255))
	newProjectile.global_position = global_position + Vector2(0, -30)
	owner.add_child(newProjectile)

func gravity():
	velocity.y += gravity * lastDelta

func check_for_next_state(condition):
	if condition:
		next_state()

func next_state():
	state += 1
	new_dialogue()
	set_physics_process(false)
	update_tooltip()
	update_animation("idle")

func new_dialogue():
	$Dialogue.d_file = "res://Assets/Dialogues/json/neko_slime_chats_Tut" + str(state) + ".json"
	$DialogueDetection/NewDialogue.show()
	$AnimationPlayer.play("newDialogueBounce")

func update_tooltip():
	if state <= len(tooltips):
		$Dialogue/Tooltip.text = tooltips[state - 1]


func _on_VisibilityNotifier2D_screen_exited():
	if leavesScene:
		queue_free()


func _on_EnemyDetection2_body_entered(body):
	print(body)


func _on_HasShotTimer_timeout():
	hasShot = true
	if state == 3:
		isPunching = true
		$AnimationPlayer.play("punch")
		$AnimationPlayer.queue("RESET")


func _on_FistHitbox3_body_entered(body):
	if body.is_in_group("Enemy"):
		body.collided_with_playerAttack()


func _on_VerticalBreakableWall_destroyed():
	next_state()
	$Dialogue.start()

func update_animation(anim):
	match anim:
		"idle": 
			$Sprite.play("idle")
			$Sprite.offset.y = -20
		
		"walk":
			$Sprite.play("walk")
			$Sprite.offset.y = -55
		
		"jump":
			$Sprite.play("jumpAway")
			$Sprite.offset.y = -20
		
		"spit":
			$Sprite.play("spit")
			$Sprite.offset.y = -20
