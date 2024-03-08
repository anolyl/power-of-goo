class_name BaseStateBoss1
extends Node

var userEntity

enum State{
	NULL,
	START,
	IDLE,
	ROAM,
	TENTACLE_ATTACK,
	CHARGE,
	STUNNED,
	DELAY,
	MOB_SPAWN_PHASE,
	DYING
}

func enter():
	pass

func exit():
	pass

func process(_delta):
	return State.NULL

func physics_process(_delta):
	return State.NULL
