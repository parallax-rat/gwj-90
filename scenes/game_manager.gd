class_name GameManager extends Node2D

const HEX_SIZE: int = 64
const CALM_SEA = preload("uid://c04uvixk0vrkq")
const YOU_WIN = preload("uid://kd0pghd0tsgm")
const YOU_LOSE = preload("uid://c2qx1ct2fbx0c")


@onready var player: Player = %Player
@onready var movement_manager: MovementManager = %MovementManager
@onready var toast_timer: Timer = %ToastTimer
@onready var ambient_light: CanvasModulate = %AmbientLight
@onready var monster: Monster = %Monster
@onready var ui: UI = %UI
@onready var tile_map_layers: Dictionary[String, TileMapLayer] = {
	"Ocean": %OceanLayer,
	"Fog": %FogLayer,
	"ThickFog": %ThickFogLayer,
	"Rocks": %RocksLayer,
	}

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


func _ready() -> void:
	tile_map_layers["Fog"].show()
	tile_map_layers["ThickFog"].show()
	ambient_light.show()
	monster.caught_player.connect(defeat)


func create_toast_message(message:String, _toast_position: Vector2 = get_local_mouse_position()) -> void:
	if !toast_timer.is_stopped():
		return
	var toast: Label = ui.TOAST_LABEL.instantiate()
	toast.text = message
	ui.toast_message_zone.add_child(toast)
	toast_timer.start()


func defeat() -> void:
	pass


func get_player_cell_position() -> Vector2:
	return GridUtils.get_cell_position_from_world_position(tile_map_layers["Ocean"],player.global_position)


func get_player_cell_coords() -> Vector2i:
	return GridUtils.get_cell_coords_from_world_position(tile_map_layers["Ocean"],player.global_position)


func get_mouse_cell_position() -> Vector2:
	return GridUtils.get_cell_position_from_mouse(tile_map_layers["Ocean"])


func get_mouse_cell_coords() -> Vector2i:
	return GridUtils.get_cell_coords_from_world_position(tile_map_layers["Ocean"],get_tree().get_root().get_mouse_position())
