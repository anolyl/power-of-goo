extends Area2D

signal transitToNewLevel

export (String, FILE) var scenePath
export (int) var entryPoint
export (bool) var isCaveExit

func _on_LevelTransition_body_entered(body):
#	print("Player entered LevelTransition")
	if body.is_in_group("Player"):
		emit_signal("transitToNewLevel", scenePath, entryPoint, isCaveExit)
