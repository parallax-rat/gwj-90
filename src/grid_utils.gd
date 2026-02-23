class_name GridUtils


static func get_cell_coords_from_mouse(tilemap: TileMapLayer) -> Vector2i:
	var local_mouse_position: Vector2 = tilemap.get_local_mouse_position()
	var cell_coords: Vector2i = tilemap.local_to_map(local_mouse_position)
	return cell_coords


static func get_cell_coords_from_world_position(tilemap: TileMapLayer, world_position: Vector2) -> Vector2i:
	var local_position: Vector2 = tilemap.to_local(world_position)
	var cell_coords: Vector2i = tilemap.local_to_map(local_position)
	return cell_coords


static func get_cell_position_from_mouse(tilemap: TileMapLayer) -> Vector2:
	var cell_coords: Vector2i = get_cell_coords_from_mouse(tilemap)
	var local_cell_position: Vector2 = tilemap.map_to_local(cell_coords)
	var global_cell_position: Vector2 = tilemap.to_global(local_cell_position)
	return global_cell_position


static func get_cell_position_from_world_position(tilemap: TileMapLayer, world_position: Vector2) -> Vector2:
	var cell_coords: Vector2i = get_cell_coords_from_world_position(tilemap, world_position)
	var local_cell_position: Vector2 = tilemap.map_to_local(cell_coords)
	var global_cell_position: Vector2 = tilemap.to_global(local_cell_position)
	return global_cell_position
