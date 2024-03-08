extends Node
class_name PLAYER_BASE_STATE

export (String) var intro_animation_name
export (String) var animation_name
export (float) var collisionRadius = 11.67
export (Vector2) var collisionOffset = Vector2(0, -1.68)

var player: Player
var collisionShape: CollisionShape2D
var onState = false

enum State {
	IDLE,
	MOVE,
	JUMP,
	FALL,
	SLIDE,
}

func enter():
	onState = true

	if intro_animation_name:
		player.animations.play(intro_animation_name)
		yield(player.animations, "animation_finished")
		if onState:
			player.animations.play(animation_name)
	else:
		if animation_name:
			player.animations.play(animation_name)

	collisionShape = player.get_node("CollisionShape2D")

	if collisionRadius != 11.67:
		collisionShape.shape.radius = collisionRadius
	else:
		collisionShape.shape.radius = 11.67

	if collisionOffset:
		collisionShape.position = collisionOffset
	else:
		collisionShape.position = Vector2(0, -1.68)

	pass
	
func exit():
	onState = false
	pass

func input(event):
	return null

func process(delta):
	return null

func physics_process(delta):
	return null
