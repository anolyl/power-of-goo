extends AudioStreamPlayer2D

func _on_GrowlTimer_timeout():
	$GrowlTimer.wait_time = rand_range(10, 20)
	pitch_scale = rand_range(.5, 1)
	play()
