extends Node2D

func _on_BreathTimer_timeout():
	$BreathTimer.wait_time = rand_range(5, 10)
	$Breath.pitch_scale = rand_range(.75, 2)
	$Breath.play()
