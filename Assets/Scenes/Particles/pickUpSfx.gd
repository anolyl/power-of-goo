extends Node2D

var time = 5

func _ready():
	$Particle1.emitting = true
	$Particle2.emitting = true
	$AudioStreamPlayer2D.playing = true
	yield(get_tree().create_timer(time), "timeout")
	queue_free()
