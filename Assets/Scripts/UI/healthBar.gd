extends Node

func _ready():
	pass

func setHealth(amt):
	self.texture.set_current_frame(amt)
