extends Control

signal skip

func _on_Button_pressed():
	emit_signal("skip")
