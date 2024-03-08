extends StaticBody2D

signal destroyed
signal hit

export var health = 3

func collided_with_playerAttack():
	if UnlockedSkills.is_ability_unlocked("strongPunch"):
		health -= 1
	
	if health <= 0:
		var root = get_tree().get_root()
		var main = root.get_node("main")
		var libraries = main.get_node("Libraries")
		var saveManager = libraries.get_node("saveManager")
		
		var currentLevelHolder = main.get_node("CurrentLevel")
		var currentLevel = currentLevelHolder.get_children()[0]

		saveManager.append_to_be_destroyed(currentLevel, self)
		destroy()
	else:
		crack_and_shake()

func crack_and_shake():
	$AnimationPlayer.play("hitByPlayer")
	
	if UnlockedSkills.is_ability_unlocked("strongPunch"):
		$Sprite.frame += 1
	emit_signal("hit")

func destroy():
	emit_signal("destroyed")
	queue_free()
