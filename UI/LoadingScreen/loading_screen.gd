extends Node

onready var loading_scene = preload("res://UI/LoadingScreen/LoadingScreen.tscn")

func load_scene(current_scene, next_scene):
	settings.currentResolution = Vector2(640, 360)
	var loading_scene_instance = loading_scene.instance()
	get_tree().get_root().call_deferred("add_child", loading_scene_instance)
	
	var loader = ResourceLoader.load_interactive(next_scene)
	
	if loader == null:
		
#		print("error")
		return
	
	current_scene.queue_free()
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	while true:
		var error = loader.poll()
		
		if error == OK:
#			var progress_bar = loading_scene_instance.get_node("ProgressBar")
#			progress_bar.value = float(loader.get_stage())/loader.get_stage_count() * 100
			var animation = loading_scene_instance.get_node("AnimatedSprite")
			var circle = loading_scene_instance.get_node("LoadingCircle")
			animation.play("default")
			circle.rotation += .1
		
		elif error == ERR_FILE_EOF:
			var scene = loader.get_resource().instance()
			
			get_tree().get_root().call_deferred("add_child", scene)
			
			loading_scene_instance.queue_free()
			return
		else:
#			print("Error whilst loading scene")
			return
		
		yield(get_tree().create_timer(0.001), "timeout")
