extends Area2D

@onready var ocean_layer: Map = $"../../OceanLayer"

var hovering_cell

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	var cell = ocean_layer.local_to_map(get_global_mouse_position())
	var cell_coords = ocean_layer.map_to_local(cell)
