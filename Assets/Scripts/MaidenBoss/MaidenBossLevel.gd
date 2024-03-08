extends Node2D

func setup_boss():
	$LevelParts/Enemies/MaidenBoss.setup($ProjectileParent, $Enemies, $player, $ChargeStart1, $ChargeStart2, $RoamCenter)


func _on_VerticalBreakableWall_hit():
	$LevelParts/Enemies/MaidenBoss.play_laugh_sound()


func _on_MaidenBoss_hasDied(_t, _y):
	$LevelParts/BreakableWalls/VerticalBreakableWall.queue_free()
