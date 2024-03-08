class_name BaseState
extends Node

export (NodePath) var enemy

enum State{
	NULL,
	IDLE,
	NEW_DIRECTION,
	PATROL,
	APPROACH,
	CHARGE,
	RETREAT,
	SEARCH,
	SLIMED
}

func enter():
	pass

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(_delta):
	return State.NULL
