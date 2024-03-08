extends Node2D

var voiceLines = []

var voiceLineCounter

func _ready():
	voiceLineCounter = 0
	for audioFile in range(1, 13):
		var path = str("res://Assets/MusicAndSounds/IntroSequence/Page", audioFile, ".wav")
		voiceLines.append(load(path))
	print(voiceLines)
	$VoiceLines.stream = voiceLines[voiceLineCounter]
	show_next_plotPoint()

func show_next_plotPoint():
	$AnimationPlayer.play("showImage")
	start_audio()

func hide_plotPoint():
	$AnimationPlayer.play("hideImage")

func start_audio():
	$VoiceLines.play()

func _on_AudioStreamPlayer_finished():
	hide_plotPoint()
	yield($AnimationPlayer, "animation_finished")
	check_if_last_plotPoint()
	$AnimationPlayer.play("flipPage")
	$Images.frame += 1
	yield($AnimationPlayer, "animation_finished")
	
	voiceLineCounter += 1
	$VoiceLines.stream = voiceLines[voiceLineCounter]
	print($VoiceLines.stream)
	show_next_plotPoint()

func check_if_last_plotPoint():
	if $Images.frame >= $Images.frames.get_frame_count($Images.animation) - 1:
		load_main_scene()


func _on_Control_skip():
	load_main_scene()

func load_main_scene():
	loadingScreen.load_scene(self, "res://Main/main.tscn")
