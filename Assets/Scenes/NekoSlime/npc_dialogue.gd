extends Area2D

func _input(event):
	if event.is_action_pressed("interact") and len(get_overlapping_bodies()) > 0:
		turn_to_player()
		
		use_dialogue()

func turn_to_player():
	if get_overlapping_bodies()[0].global_position.x < global_position.x:
		owner.get_node("Sprite").flip_h = true
	else:
		owner.get_node("Sprite").flip_h = false

func use_dialogue():
	var dialogue = owner.get_node("Dialogue")
	
	if dialogue:
		dialogue.start()
		$NewDialogue.hide()


func _on_Area2D_body_entered(body):
	$Label.show()


func _on_Area2D_body_exited(body):
	$Label.hide()
