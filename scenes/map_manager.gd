class_name MapManager extends Node

@onready var fog_layer: TileMapLayer = %FogLayer
@onready var mapping_progress: ProgressBar = %MappingProgress


@onready var fog_to_map: float = get_cell_count()
var fog_mapped: float = 0

func _ready() -> void:
	mapping_progress.max_value = fog_to_map
	mapping_progress.value = (fog_mapped / fog_to_map) * 100
	prints("Total Fog Cells:",fog_to_map)

func get_cell_count() -> float:
	return fog_layer.get_used_cells().size()


func update_map_progress_bar() -> void:
	var _progress = (fog_mapped / fog_to_map) * 100
	var tween = get_tree().create_tween()
	tween.tween_property(mapping_progress,"value",_progress,1.0)


func update_mapped_fog() -> void:
	fog_mapped += 1
	update_map_progress_bar()
	
