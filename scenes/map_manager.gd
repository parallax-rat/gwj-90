class_name MapManager extends Node

@onready var fog_layer: TileMapLayer = %FogLayer

var starting_fog: int
var current_fog: int

func get_starting_cell_count() -> int:
	return fog_layer.get_used_cells().size()
