extends Node2D

export (NodePath) var followingNode
export (NodePath) var nodeThatFollows

export (Vector2) var followingOffset = Vector2(0, 0)

export (float) var flyingbouncespeed = 1.0
export (float) var amplitude = 4.0

onready var phase : float = 0.0
onready var verticalInvolvement: float = 0.0

onready var followingNodeObject : Node
onready var nodeThatFollowsObject : Node

func _ready():
	followingNodeObject = get_node(followingNode)
	nodeThatFollowsObject = get_node(nodeThatFollows) if nodeThatFollowsObject else self

func _physics_process(_delta):
	phase = phase + _delta * flyingbouncespeed
	verticalInvolvement = sin(phase) * amplitude

	if followingNode and followingNodeObject and global_transform:
		var interpol = nodeThatFollowsObject.global_position.linear_interpolate(followingNodeObject.global_position + followingOffset + Vector2(0, verticalInvolvement), 0.6)
		nodeThatFollowsObject.global_position = interpol
