extends Node2D

export (PackedScene) var Pause_MenuTemplate
export (PackedScene) var cranberryTemplate
export (PackedScene) var hitEffectTemplate
export (PackedScene) var defaultStarterLevel = preload("res://Assets/Scenes/Levels/Tutorial_Room_new.tscn")
export(float, 0, 1) var cranberryDroprate = .25
export (float) var impactPauseTimer = .2

var isPaused

var gameBeaten

var currentLevel
var player
var currentNekoSlime : KinematicBody2D

var enteredBossRoom

var musicStopped

var currentPause_Menu = null

onready var masterSlider = $PauseMenu/Sub_Options_Sound_Buttons/MasterVolumeMarginContainer/MasterVolumeHBoxContainer/Master_Volume_Slider_Container/MasterMarginContainer/MasterVolumeSlider
onready var musicSlider = $PauseMenu/Sub_Options_Sound_Buttons/MusicVolumeMarginContainer/MusicHBoxContainer/MusicVolumeSliderContainer/MusicMarginContainer/MusicVolumeSlider
onready var sfxSlider = $PauseMenu/Sub_Options_Sound_Buttons/SFXMarginContainer/SFXHBoxContainer/SFXVolumeSliderContainer/SFXMarginContainer/SFXVolumeSlider
onready var borderlessCheckbox = $PauseMenu/Sub_Options_Video_Buttons/MasterVolumeMarginContainer/MasterVolumeHBoxContainer/Master_Volume_Slider_Container/MasterMarginContainer/FullScreenCheckbox

func _ready():
	settings.currentResolution = Vector2(1280, 720)
	randomize()
	isPaused = false
	gameBeaten = false
	enteredBossRoom = false
	musicStopped = false
	
	set_current_level()
	setup_sound_volume()
	setup_video_options()
	setup_level(0)
	$ImpactPauseTimer.wait_time = impactPauseTimer

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not isPaused:
		if self:
			pause_game()
		return
	
	if Input.is_action_just_pressed("pause") and isPaused:
		resume_game()

func pause_game():
	if is_instance_valid(currentNekoSlime):
		currentNekoSlime.pause_mode = 1
	
	get_tree().paused = true
	
#	var newPauseMenu = Pause_MenuTemplate.instance()
#	add_child(newPauseMenu)
#	newPauseMenu.connect("resume_game", self, "resume_game")
#	newPauseMenu.connect("return_to_main_menu", self, "return_to_main_menu")
#
#	currentPause_Menu = newPauseMenu
	
	$PauseMenu/PauseMenu1.show()
	$PauseMenu/TextureRect.show()
	
	isPaused = true

func resume_game():
	
	if is_instance_valid(currentNekoSlime):
		currentNekoSlime.pause_mode = 2
	
	get_tree().paused = false
	
#	currentPause_Menu.disconnect("resume_game", self, "resume_game")
#	currentPause_Menu.disconnect("return_to_main_menu", self, "return_to_main_menu")
#	currentPause_Menu.queue_free()
#	currentPause_Menu = null
	
	for node in $PauseMenu.get_children():
		node.hide()
	
	isPaused = false

#==============PAUSEMENU 1======================

func _on_ContinueButton_pressed():
	resume_game()

func _on_OptionsButton_pressed():
	$PauseMenu/PauseMenu1.hide()
	$PauseMenu/PauseMenu2.show()

func _on_QuitButton_pressed():
	return_to_main_menu()

#=================================================
#=========PAUSEMENU 2=============================

func _on_SoundButton_pressed():
	$PauseMenu/Sub_Options_Video_Buttons.hide()
	$PauseMenu/Sub_Options_Control.hide()
	$PauseMenu/Sub_Options_Sound_Buttons.show()

func _on_VideoButton_pressed():
	$PauseMenu/Sub_Options_Sound_Buttons.hide()
	$PauseMenu/Sub_Options_Control.hide()
	$PauseMenu/Sub_Options_Video_Buttons.show()

func _on_ControlButton_pressed():
	$PauseMenu/Sub_Options_Sound_Buttons.hide()
	$PauseMenu/Sub_Options_Video_Buttons.hide()
	$PauseMenu/Sub_Options_Control.show()

func _on_BackButton_pressed():
	$PauseMenu/Sub_Options_Sound_Buttons.hide()
	$PauseMenu/Sub_Options_Video_Buttons.hide()
	$PauseMenu/Sub_Options_Control.hide()
	$PauseMenu/PauseMenu2.hide()
	$PauseMenu/PauseMenu1.show()

#=================================================
#============Sub_Options_Sound====================

func setup_sound_volume():
	musicSlider.value = settings.music_volume 
	masterSlider.value = settings.master_volume 
	sfxSlider.value = settings.sfx_volume

func _on_MasterVolumeSlider_value_changed(value):
	settings.change_master_volume(value)

func _on_MusicVolumeSlider_value_changed(value):
	settings.change_music_volume(value)

func _on_SFXVolumeSlider_value_changed(value):
	settings.change_sfx_volume(value)

#==================================================
#===============Sub_Video_Options==================

func setup_video_options():
	borderlessCheckbox.pressed = OS.window_borderless

func _on_FullScreenCheckbox_toggled(value):
	OS.window_borderless = value

#==================================================
#================Sub_Control_Options===============

#==================================================
func return_to_main_menu():
	loadingScreen.load_scene(self, "res://UI/MainMenu/Menu.tscn")
	get_tree().paused = false

func _on_enemy_has_died(enemyPos, isBoss = false):
	if isBoss:
		get_tree().paused = true
		UnlockedSkills.unlock_ability("bossBeaten")
	_try_spawn_cranberry(enemyPos)
	_spawn_death_effect(enemyPos)

func _try_spawn_cranberry(enemyPos):
	if randf() < cranberryDroprate:
		var newCranberry = cranberryTemplate.instance()
		newCranberry.linear_velocity.y = -100
		newCranberry.global_position = enemyPos + Vector2(0, -20)
		$Cranberries.call_deferred("add_child", newCranberry)
		
		#First cranberry will drop with 100% chance, afterwards it's set to 25%
		cranberryDroprate = .25


func _spawn_death_effect(enemyPos):
	var newHitEffect = hitEffectTemplate.instance()
	newHitEffect.global_position = enemyPos + Vector2(0, -50)

	newHitEffect.process_material.direction.x = (enemyPos - player.global_position).x
	newHitEffect.process_material.direction.y = (enemyPos - player.global_position).y
	
	add_child(newHitEffect)
	
	camera_shake(true)

func camera_shake(pauseOnImpact = false):
	$Libraries/shaker._shake(player.get_node("Camera2D"), 4.5, 7.15, 1.15)
	if pauseOnImpact:
		impact_pause()


func impact_pause():
	$ImpactPauseTimer.start()
	get_tree().paused = true

func _on_ImpactPauseTimer_timeout():
	get_tree().paused = false

func _on_player_hasDied():
	get_tree().paused = true
	yield(get_tree().create_timer(1), "timeout")
	$AnimationPlayer.play("fade_to_black")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		get_tree().paused = false
		if gameBeaten:
			var _tmp = get_tree().change_scene("res://UI/WinScreen/WinScreen.tscn")
			queue_free()
		else:
			var _tmp = get_tree().change_scene("res://UI/GameOverScreen/GameOverScreen.tscn")
			queue_free()

func _on_LevelTransition_transitToNewLevel(scenePath, entryPoint, isGameEnd):
	if isGameEnd:
		get_tree().change_scene(scenePath)
		queue_free()
		return
	
	var playerCranberries = player.cranberryAmount
	var playerHealth = player.health

	for cranberry in $Cranberries.get_children():
		if is_instance_valid(cranberry.queue_free()):
			cranberry.queue_free()

	currentLevel.queue_free()
	
	var levelTemplate = load(scenePath)
	var newLevel = levelTemplate.instance()
	$CurrentLevel.call_deferred("add_child", newLevel)
	
	$Libraries/saveManager.save_player(player)
	
	currentLevel = newLevel
	call_deferred("setup_level", entryPoint)

func setup_level_enemies():
	var data = $Libraries/saveManager.load_game().toBeDestroyed

	var cages = currentLevel.get_node("Cages")
	if cages:
		for node in cages.get_children():
			if data.has(currentLevel.name + '_' + node.name):
				node.queue_free()

	for node in currentLevel.get_children():
		if node.is_in_group("LevelParts"):
			for enemy in node.get_enemies():
				if data.has(currentLevel.name + '_' + enemy.name):
					enemy.queue_free()
				if enemy.has_method("setup_projectileParent"):
					enemy.setup_projectileParent($ProjectileParent)
				
				if enemy.is_in_group("MaidenBoss"):
					currentLevel.setup_boss()
					enteredBossRoom = true
					$BGM.stop()
					$BGM.stream = load("res://Assets/MusicAndSounds/BGM/BossMusic.mp3")
					$BGM.play()
				
				elif enteredBossRoom:
					enteredBossRoom = false
					$BGM.stop()
					$BGM.stream = load("res://Assets/MusicAndSounds/BGM/GameMusic_nightmare by Tausdei Music.wav")
					$BGM.play()
		
		if node.is_in_group("Player"):
			node.setup_projectileParent($ProjectileParent)

func setup_level_connect_signals():
	var data = $Libraries/saveManager.load_game().toBeDestroyed
	
	for node in currentLevel.get_children():
		if data.has(currentLevel.name + '_' + node.name):
			node.queue_free()
			
		if node.is_in_group("LevelParts"):
			for enemy in node.get_enemies():
				enemy.connect("hasDied", self, "_on_enemy_has_died")
				
				if enemy.is_in_group("MaidenBoss"):
					enemy.connect("hitGround", self, "camera_shake")
					enemy.connect("hasBeenHit", self, "_spawn_death_effect")
				
			for levelTransit in node.get_levelTransits():
				levelTransit.connect("transitToNewLevel", self, "_on_LevelTransition_transitToNewLevel")
			
			for breakableWall in node.get_breakableWalls():
				if data.has(currentLevel.name + '_' + breakableWall.name):
					breakableWall.queue_free()
				else:
					breakableWall.connect("destroyed", self, "camera_shake")
		
		if node.is_in_group("Player"):
			node.connect("hasDied", self, "_on_player_hasDied")

func setup_player(entryPoint):
	for node in currentLevel.get_children():
		if node.is_in_group("Player"):
			player = node
	
	for node in currentLevel.get_children():
		if node.is_in_group("LevelParts"):
			for entryPoints in node.get_entryPoints():
				if entryPoints.name == str(entryPoint):
					player.set_deferred("global_position", entryPoints.global_position)

	var playerVars = $Libraries/saveManager.load_game().player
	if playerVars != null:
		player.setHealthAmt(4)
		player.setCranberryAmt(playerVars.cranberries)
		if playerVars.currentCheckpoint:
			var convertedCheckpointLocation = playerVars.currentCheckpoint.replace("(", "").replace(")", "").split(", ")
			player.global_position = Vector2(convertedCheckpointLocation[0], convertedCheckpointLocation[1])

func setup_nekoSlime():
	var nekoSlimeActive = false
	var newNekoSlime
	for node in currentLevel.get_children():
		if node.name == "nekoSlime":
			nekoSlimeActive = true
			newNekoSlime = node
	
	if nekoSlimeActive:
		currentNekoSlime = newNekoSlime
	else:
		currentNekoSlime = null 

func setup_level(entryPoint):
	setup_level_enemies()
	setup_level_connect_signals()
	setup_player(entryPoint)
	setup_nekoSlime()

func set_current_level():
	if $CurrentLevel.get_children().size() == 0:
		var defaultLevel = defaultStarterLevel.instance()
		$CurrentLevel.add_child(defaultLevel)
		currentLevel = defaultLevel
	else:
		var playerVars = $Libraries/saveManager.load_game().player
		if playerVars != null:
			$CurrentLevel.get_children()[0].queue_free()
			print(playerVars)
			var levelTemplate = load("res://Assets/Scenes/Levels/%s.tscn" % playerVars.currentScene)
			var newLevel = levelTemplate.instance()
			$CurrentLevel.call_deferred("add_child", newLevel)
			currentLevel = newLevel
		else:
			currentLevel = $CurrentLevel.get_children()[0]

func get_player():
	return player

func _on_BGM_finished():
	if not musicStopped:
		$BGM.play()

func get_data():
	pass #todo - return checkpoints and current level scene
