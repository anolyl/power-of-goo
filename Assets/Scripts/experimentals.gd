extends Node

# Declare exported variables here, then to call from other scripts.
# Make sure to have the Node present with this script.

export (bool) var cameraZoomZones

# Ignore rest unless you know what you're doing

func _ready():
	pass

func requestExperimental(feature) -> bool:
	match feature:
		"cameraZoomZones":
			return cameraZoomZones
		_:
			return false