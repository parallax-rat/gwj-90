extends Node

const HEX_SIZE = 64

var player: Player
var ui: UI
var tile_map_layers: Dictionary[String, TileMapLayer]

# stats
var mapped: float = 0
var moves: int = 0
var fog_cleared: int = 0
var scans: int = 0
var times_rested: int = 0

func reset_stats():
	mapped = 0.0
	moves = 0
	scans = 0
	times_rested = 0


func get_player_cell_position() -> Vector2:
	return GridUtils.get_cell_position_from_world_position(tile_map_layers["Ocean"],player.global_position)

func get_player_cell_coords() -> Vector2i:
	return GridUtils.get_cell_coords_from_world_position(tile_map_layers["Ocean"],player.global_position)

func get_mouse_cell_position() -> Vector2:
	return GridUtils.get_cell_position_from_mouse(tile_map_layers["Ocean"])

func get_mouse_cell_coords() -> Vector2i:
	return GridUtils.get_cell_coords_from_world_position(tile_map_layers["Ocean"],get_tree().get_root().get_mouse_position())
