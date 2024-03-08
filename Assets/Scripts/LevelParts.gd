extends Node2D

func get_enemies():
	return $Enemies.get_children()

func get_deathZones():
	return $Deathzones.get_children()

func get_levelTransits():
	return $LevelTransitionZones.get_children()

func get_entryPoints():
	return $EntryPoints.get_children()

func get_breakableWalls():
	return $BreakableWalls.get_children()
