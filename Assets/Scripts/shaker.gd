extends Node
class_name Shaker

var rng = RandomNumberGenerator.new()

var ranFor = 0
var nodesToBeShaken = {}

var whiteListedNodes = ["Camera2D", "Sprite", "AnimatedSprite"]

func _shake(node, amt, freq, dur, fadeIn = 0):
	if node.get_class() in whiteListedNodes:
		ranFor = dur
		nodesToBeShaken[node] = [amt, freq, dur, fadeIn, node.get_offset()]

func _physics_process(delta):
	for i in nodesToBeShaken:
		var node = i
		var amt = nodesToBeShaken[i][0]
		var freq = nodesToBeShaken[i][1]
		var dur = nodesToBeShaken[i][2]
		var fadeIn = nodesToBeShaken[i][3]
		var oldOffset = nodesToBeShaken[i][4]

		if is_instance_valid(node):
			rng.randomize()
				
			amt = amt * (ranFor / dur)
			node.set_offset(oldOffset + Vector2(rng.randf_range(-amt, amt), rng.randf_range(-amt, amt)))
			
			ranFor -= delta
			if ranFor <= 0:
				node.set_offset(oldOffset)
				nodesToBeShaken.erase(node)
		

