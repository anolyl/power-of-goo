extends RigidBody2D

func _ready():
	$AnimatedSprite.play("escape")
	$Timer.start()

func setup(color):
	$AnimatedSprite.modulate = color
	pass

func _on_Timer_timeout():
	$AnimatedSprite.play("happy")
	start_dialogue()

func start_dialogue():
	$Dialogue.start()


func _on_Dialogue_dialogueFinished():
	$AnimationPlayer.play("vanish")
