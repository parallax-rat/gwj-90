extends Node2D

@onready var fog_node: PackedScene = preload("res://scenes/fog.tscn")
@onready var tile_map_layer: TileMapLayer = $"../TileMapLayer"
@onready var fog_container: Node2D = $Fog

func _ready() -> void:
	var used_cells: Array[Vector2i] = tile_map_layer.get_used_cells()
	
	for cell_coord in used_cells:
		var cell_position: Vector2 = cell_coord * Global.HEX_SIZE
		cell_position = cell_position + Vector2(Global.HEX_SIZE/2,Global.HEX_SIZE/2)
		if cell_position.distance_to(%Player.global_position) > Global.HEX_SIZE:
			var new_fog = fog_node.instantiate()
			fog_container.add_child(new_fog)
			new_fog.global_position = cell_position
