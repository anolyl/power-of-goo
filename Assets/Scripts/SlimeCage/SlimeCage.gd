extends StaticBody2D

export (PackedScene) var escapedSlimeTemplate

signal hasBeenBroken

var isBroken

func _ready():
	randomize()
	isBroken = false
	$Slime.modulate = Color(rand_range(150.0, 255.0) / 255, rand_range(150.0, 255.0) / 255, rand_range(150.0, 255.0) / 255)

func collided_to_cage(player):
	if not isBroken:
		isBroken = true
		$Cage.animation = "broken"
		$Cage.frame = randi() % 4
		$Slime.hide()
		
		emit_signal("hasBeenBroken")
		
		collision_layer = 0
		collision_mask = 0
		
		var newEscapedSlime = escapedSlimeTemplate.instance()
		
		newEscapedSlime.linear_velocity = Vector2(20, -100)
		newEscapedSlime.setup($Slime.modulate)
		newEscapedSlime.global_position = global_position
		
		if $Cage.animation == "broken" and $Cage.frame == 0:
			queue_free()
		
		var root = get_tree().get_root()
		var main = root.get_node("main")
		var libraries = main.get_node("Libraries")
		var saveManager = libraries.get_node("saveManager")

		var currentLevelHolder = main.get_node("CurrentLevel")
		var currentLevel = currentLevelHolder.get_children()[0]

		player.addSlimesRescued()				
		saveManager.addRescued()
		saveManager.append_to_be_destroyed(currentLevel, self)
		
		owner.call_deferred("add_child", newEscapedSlime)
		
		if has_node("NewDialogue"):
			$NewDialogue.hide()
