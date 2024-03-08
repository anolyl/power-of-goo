extends Control

var winTexts = ["Little Goo has overcome what others could not."]

func _ready():
	get_tree().paused = false
	settings.currentResolution = Vector2(640, 360)
	randomize()
	winTexts.shuffle()
	$YouWin.text = winTexts.front()
	$AnimationPlayer.play("fade_in")


func _on_Restart_pressed():
	get_tree().change_scene("res://Main/main.tscn")


func _on_MainMenu_pressed():
	loadingScreen.load_scene(self, "res://UI/MainMenu/Menu.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
#		print("Fade in terminated")
		$ColorRectFront.queue_free()
