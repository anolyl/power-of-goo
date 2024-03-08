tool
extends TileSet

func _is_tile_bound(drawn_id: int, neighbor_id: int) -> bool:
	return get_tiles_ids().has(neighbor_id)
