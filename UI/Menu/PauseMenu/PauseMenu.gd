extends Control

export (PackedScene) var optionsMenuTemplate

var currentOptionsMenu

var isInOptions

signal resume_game
signal return_to_main_menu

func _on_ResumeButton_pressed():
	emit_signal("resume_game")


func _on_MainMenuButton_pressed():
	emit_signal("return_to_main_menu")


func _on_OptionsButton_pressed():
	if not isInOptions:
		isInOptions = true
		var newOptionsMenu = optionsMenuTemplate.instance()
		currentOptionsMenu = newOptionsMenu
		newOptionsMenu.connect("back_to_last_menu", self, "close_Options")
		
		add_child(newOptionsMenu)
		
		$PauseMenu.hide()
	

func close_Options():
	isInOptions = false
	currentOptionsMenu.disconnect("back_to_last_menu", self, "close_Options")
	currentOptionsMenu.queue_free()
	
	currentOptionsMenu = null
	
	$PauseMenu.show()
