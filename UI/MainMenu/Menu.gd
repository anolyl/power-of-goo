extends Node2D

enum {
	START,
	TITLE_SCREEN,
	MAIN_MENU,
	OPTIONS_MENU,
	CREDITS
}

export (PackedScene) var optionsMenuTemplate

var currentOptionsMenu
var state

var musicStopped

var highAlpha

func _ready():
	musicStopped = false
	highAlpha = true
	settings.currentResolution = Vector2(640,360)
	change_music_volume(settings.music_volume)
	state = START
	for child in $CanvasLayer/Control.get_children():
		child.hide()

func _input(event):
	if state == TITLE_SCREEN and not event.is_class("InputEventMouseMotion"):
		state = MAIN_MENU
		$CanvasLayer/Control/PressAnyButton.hide()
		$CanvasLayer/AnimatedSprite.play("openBook")
		#$CanvasLayer/Control/MainMenuWireframe.show()

func _process(delta):
	match state:
		START:
			$BlackCover.self_modulate.a -= delta
			if $BlackCover.self_modulate.a < .1:
				$CanvasLayer/Control/PressAnyButton.show()
				$BlackCover.hide()
				state = TITLE_SCREEN
		
		TITLE_SCREEN:
			if highAlpha:
				$CanvasLayer/Control/PressAnyButton.self_modulate.a -= delta
				if $CanvasLayer/Control/PressAnyButton.self_modulate.a < .1:
					highAlpha = false
			else:
				$CanvasLayer/Control/PressAnyButton.self_modulate.a += delta
				if $CanvasLayer/Control/PressAnyButton.self_modulate.a > .9:
					highAlpha = true
			
			

func _on_Main_Menu_quit():
	get_tree().quit()

func _on_Main_Menu_continueGame():
	$Libraries/saveManager.load_game()
	loadingScreen.load_scene(self, "res://Main/main.tscn")

func _on_Main_Menu_newGame():
	$Libraries/saveManager.reset_data()
	loadingScreen.load_scene(self, "res://UI/IntroSequence/IntroSequence.tscn")


func _on_Main_Menu_options():
	var newOptionsMenu = optionsMenuTemplate.instance()
	newOptionsMenu.connect("back_to_last_menu", self, "return_from_options")
	currentOptionsMenu = newOptionsMenu
	
	$CanvasLayer/Control/Main_Menu.hide()
	$CanvasLayer/Control/Label.hide()
	
	$AnimationPlayer.play("flipPage")
	yield($AnimationPlayer, "animation_finished")
	
	$CanvasLayer.add_child(newOptionsMenu)
	

func _on_BossTestButton_pressed():
	var _tmp = get_tree().change_scene("res://Assets/Scenes/MaidenBoss/MaidenBossLevel.tscn")

func return_from_options():
	currentOptionsMenu.disconnect("back_to_last_menu", self, "return_from_options")
	currentOptionsMenu.queue_free()
	
	$AnimationPlayer.play_backwards("flipPage")
	yield($AnimationPlayer, "animation_finished")
	
	$CanvasLayer/Control/Main_Menu.show()
	$CanvasLayer/Control/Label.show()
	$CanvasLayer/Control.modulate = Color(1, 1, 1, 1)


func _on_AudioStreamPlayer_finished():
	if not musicStopped:
		$AudioStreamPlayer.play()


func _on_AnimatedSprite_animation_finished():
		$AnimationPlayer.play("fade_in")
		yield(get_tree().create_timer(.05), "timeout")
		$CanvasLayer/Control/Main_Menu.show()
		$CanvasLayer/Control/Label.show()

func change_music_volume(value):
	$AudioStreamPlayer.volume_db = -30 + value
	if value == 0:
		$AudioStreamPlayer.stop()
		musicStopped = true
	
	if musicStopped and value != 0:
		$AudioStreamPlayer.play()
		musicStopped = false


func _on_AnimatedSprite_frame_changed():
	if $CanvasLayer/AnimatedSprite.frame >= 60 and not currentOptionsMenu:
		$CanvasLayer/AnimatedSprite.stop()
		$AnimationPlayer.play("fade_in")
		yield(get_tree().create_timer(.05), "timeout")
		$CanvasLayer/Control/Main_Menu.show()
		$CanvasLayer/Control/Label.show()
