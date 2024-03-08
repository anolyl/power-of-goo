extends Area2D

func _ready():
	if UnlockedSkills.is_ability_unlocked("hasKey"):
		queue_free()

func _input(event):
	if monitoring and len(get_overlapping_bodies()) > 0 and event.is_action_pressed("interact"):
		UnlockedSkills.unlock_ability("hasKey")
		$E.hide()
		$Key.hide()
		owner.get_node("AnimationPlayer").play("keyFound")
		monitoring = false
		monitorable = false
		

func _on_KeyPickupRange_body_entered(body):
	$E.show()


func _on_KeyPickupRange_body_exited(body):
	$E.hide()
