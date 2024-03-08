extends Control

var gameOverTexts = ["Little Goo's story has found its end here..", "Little Goo's burden was too big to carry..", "The abyss stared back at you, Little Goo.."]

func _ready():
	settings.currentResolution = Vector2(640, 360)
	randomize()
	gameOverTexts.shuffle()
	$YouDied.text = gameOverTexts.front()
	$AnimationPlayer.play("fade_in")


func _on_Restart_pressed():
	get_tree().change_scene("res://Main/main.tscn")


func _on_MainMenu_pressed():
	loadingScreen.load_scene(self, "res://UI/MainMenu/Menu.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
#		print("Fade in terminated")
		$ColorRectFront.queue_free()
