extends Particles2D

func _ready():
	emitting = true
	$LifeTimer.createTimer(2, funcref(self, "queue_free"))
