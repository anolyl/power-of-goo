extends Camera2D

# Exportables

export (NodePath) var Camera 
export (NodePath) var Area2D 

var CameraNode
var Area2DNode

# Variables

var Zoom = Vector2(1,1)
var lockedOnNode 

# Experimentals

export (NodePath) var Experimentals
var ExperimentalsNode

# Functions

func _ready():
	ExperimentalsNode = get_node(Experimentals)
	CameraNode = get_node(Camera)
	Area2DNode = get_node(Area2D)

func _process(delta):
	if !ExperimentalsNode.requestExperimental("cameraZoomZones"):
		return

	if CameraNode != null:
		CameraNode.zoom = CameraNode.zoom.linear_interpolate(Zoom, 0.9 * delta)

func _on_Zones_body_entered(body:Node):
	if !ExperimentalsNode.requestExperimental("cameraZoomZones"):
		return

	if body.has_method("request_zoom"):
		var requestedZoom = body.request_zoom()
		if requestedZoom:
			Zoom = requestedZoom
			lockedOnNode = body

func _on_Zones_body_exited(_body:Node):
	if !ExperimentalsNode.requestExperimental("cameraZoomZones"):
		return

	if lockedOnNode == _body:
		Zoom = Vector2(1,1)


