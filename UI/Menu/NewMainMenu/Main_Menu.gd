extends Control

signal continueGame
signal newGame
signal options
signal credits
signal quit



func _on_ContinueContainer_pressed():
	emit_signal("continueGame")

func _on_NewGameButton_pressed():
	emit_signal("newGame")

func _on_OptionsButton_pressed():
	emit_signal("options")

func _on_CreditsButton_pressed():
	emit_signal("credits")

func _on_QuitButton_pressed():
	emit_signal("quit")
