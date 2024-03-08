extends BaseStateBoss1

var exitState
var sprite

func enter():
	exitState = false
	sprite = userEntity.get_node("AnimatedSprite")
	sprite.connect("animation_finished", self, "_on_animation_finished")
	sprite.play("opening")
	userEntity.play_scream_sound()

func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	if exitState:
		return State.IDLE
	
	return State.NULL

func _on_animation_finished():
	exitState = true
