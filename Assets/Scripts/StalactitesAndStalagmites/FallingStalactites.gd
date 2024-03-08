extends Node2D

export (PackedScene) var stalactiteDustTemplate
export var rightStalactiteWaitTimer = .4

var counter

func _ready():
	counter = 0
	
	$RightStalTimer.wait_time = rightStalactiteWaitTimer
	
	$StalactiteR.collision_layer = $StalactiteL.collision_layer
	$StalactiteR.collision_mask = $StalactiteL.collision_mask

func _process(delta):
	aim()

func aim():
	var collider = $RayCast2D.get_collider()
	if collider and collider.is_in_group("Player"):
		$DustTimer.stop()
		drop_stalactites()

func drop_stalactites():
	set_process(false)
	if $StalactiteL:
		$StalactiteL.drop()
	$RightStalTimer.start()


func _on_RightStalTimer_timeout():
	if $StalactiteR:
		$StalactiteR.drop()

func check_if_stalactite_left():
	counter += 1
	if counter >= 2:
		queue_free()


func _on_DustTimer_timeout():
	$DustTimer.wait_time = rand_range(.75, 1.6)
	var newStalactiteDust = stalactiteDustTemplate.instance()
	add_child(newStalactiteDust)
	newStalactiteDust.global_position = $StalactiteR/Target.global_position
