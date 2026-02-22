class_name MapManager extends Node

@onready var fog_layer: TileMapLayer = %FogLayer
@onready var ocean_layer: TileMapLayer = %OceanLayer
@onready var mapping_progress: ProgressBar = %MappingProgress


@onready var fog_to_map: float = get_cell_count()
var fog_mapped: float = 0

func _ready() -> void:
	mapping_progress.max_value = fog_to_map
	mapping_progress.value = (fog_mapped / fog_to_map) * 100
	prints("Total Fog Cells:",fog_to_map)

func get_cell_count() -> float:
	var count = 0
	for cell in ocean_layer.get_used_cells():
		var tile_data = ocean_layer.get_cell_tile_data(cell)
		if tile_data:
			var data = tile_data.get_custom_data("to_be_mapped")
			if data == true:
				count+=1
	#return fog_layer.get_used_cells().size()
	return count

func update_map_progress_bar() -> void:
	print("fog_mapped ", fog_mapped)
	print("fog_to_map ", fog_to_map)
	var _progress = (fog_mapped / fog_to_map) * 100
	print("progress ", _progress)
	Global.mapped = _progress
	var tween = get_tree().create_tween()
	tween.tween_property(mapping_progress,"value",_progress,1.0)


func update_mapped_fog(area: Area2D) -> void:
	var cell = ocean_layer.local_to_map(ocean_layer.to_local(area.global_position))
	var tile_data = ocean_layer.get_cell_tile_data(cell)
	if tile_data and tile_data.get_custom_data("to_be_mapped"):
		fog_mapped += 1
	update_map_progress_bar()
	
