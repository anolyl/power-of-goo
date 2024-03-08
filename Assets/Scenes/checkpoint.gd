extends Area2D

func _on_Checkpoint_body_entered(body):
	if body.is_in_group("Player"):
		var currentScene = get_tree().get_root()

		if currentScene != null:
			var main = currentScene.get_node("main")

			if main != null and body != null:
				
				var Libraries = main.get_node("Libraries")
				var saveManager = Libraries.get_node("saveManager")

				if saveManager != null:
					body.currentCheckpoint = self.get_node("spawn").global_position
					saveManager.save_player(body)
