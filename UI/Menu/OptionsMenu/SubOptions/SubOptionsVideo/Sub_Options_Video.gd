extends Control

onready var borderlessCheckbox = $Sub_Options_Video_Buttons/MasterVolumeMarginContainer/MasterVolumeHBoxContainer/Master_Volume_Slider_Container/MasterMarginContainer/FullScreenCheckbox

func _ready():
	borderlessCheckbox.pressed = OS.window_borderless


func _on_FullScreenCheckbox_toggled(button_pressed):
	OS.window_borderless = button_pressed
