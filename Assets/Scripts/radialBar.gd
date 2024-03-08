extends Node

export (float) var ProgressTime = 1.0
export (float) var RecoveryTime = 22.0

export (NodePath) var AnimatedSpritePath
onready var animatedSprite

onready var progressPlaying = false
onready var passedProgress = false
onready var currentProgress = 0.0

func _ready():
	animatedSprite = get_node(AnimatedSpritePath)

	if ProgressTime == 0.0:
		ProgressTime = 0.001

	assert(animatedSprite != null)
	assert(animatedSprite is AnimatedSprite)

	animatedSprite.visible = false

func takeBars():
	animatedSprite.frame = 0
	animatedSprite.visible = true
	progressPlaying = true
	$AnimatedSprite/AnimationPlayer.play_backwards("Opacity")

func disableBars():
	progressPlaying = false
	$AnimatedSprite/AnimationPlayer.play("Opacity")
	yield($AnimatedSprite/AnimationPlayer, "animation_finished")
	animatedSprite.visible = false

func _process(delta):
	if currentProgress >= 35 and $AnimatedSprite/AnimationPlayer.current_animation != "Color":
		$AnimatedSprite/AnimationPlayer.play("Color")
	elif currentProgress < 35 and $AnimatedSprite/AnimationPlayer.current_animation == "Color":
		$AnimatedSprite/AnimationPlayer.play_backwards("Color")

	if animatedSprite.visible and progressPlaying:
		if currentProgress == animatedSprite.frames.get_frame_count("progress"):
			passedProgress = true
		elif !passedProgress: 
			currentProgress = clamp(currentProgress + delta * 55 / ProgressTime, 0, animatedSprite.frames.get_frame_count("progress"))
		
		if passedProgress:
			currentProgress = clamp(currentProgress - delta * 55 / RecoveryTime, 0, animatedSprite.frames.get_frame_count("progress"))
			if currentProgress == 0:
				progressPlaying = false
				passedProgress = false
				disableBars()
	

	animatedSprite.frame = currentProgress

