extends Control

export (PackedScene) var subOptionsSoundMenuTemplate
export (PackedScene) var subOptionsVideoMenuTemplate
export (PackedScene) var subOptionsControlMenuTemplate

signal back_to_last_menu
var currentSubOption
var possibleResolutions = [Vector2(640,360), Vector2(1280, 720), Vector2(1920, 1080)]

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_on_BackButton_pressed()

func _ready():
	rect_size = settings.currentResolution
	
#	for resolution in possibleResolutions:
#		$Control/VBoxContainer/ResolutionSelection.add_item(str(resolution.x, " x ", resolution.y))
#		if resolution == settings.currentResolution:
#			$Control/VBoxContainer/ResolutionSelection.select(possibleResolutions.find(resolution))


func _on_BackButton_pressed():
	emit_signal("back_to_last_menu")


func _on_SoundButton_pressed():
	var newSubOptionSound = subOptionsSoundMenuTemplate.instance()
	if currentSubOption:
		currentSubOption.queue_free()
	currentSubOption = newSubOptionSound
	$Suboptions.add_child(newSubOptionSound)


func _on_VideoButton_pressed():
	var newSubOptionVideo = subOptionsVideoMenuTemplate.instance()
	if currentSubOption:
		currentSubOption.queue_free()
	currentSubOption = newSubOptionVideo
	$Suboptions.add_child(newSubOptionVideo)


func _on_ControlButton_pressed():
	var newSubOptionControl = subOptionsControlMenuTemplate.instance()
	if currentSubOption:
		currentSubOption.queue_free()
	currentSubOption = newSubOptionControl
	$Suboptions.add_child(newSubOptionControl)
