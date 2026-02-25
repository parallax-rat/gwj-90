class_name GameManager extends Node2D

const CALM_SEA = preload("uid://c04uvixk0vrkq")
const YOU_WIN = preload("uid://kd0pghd0tsgm")
const YOU_LOSE = preload("uid://c2qx1ct2fbx0c")


@onready var player: Player = %Player
@onready var movement_manager: MovementManager = %MovementManager
@onready var toast_timer: Timer = %ToastTimer
@onready var ambient_light: CanvasModulate = %AmbientLight
@onready var monster: Monster = %Monster
@onready var ui: UI = %UI



func _ready() -> void:
	call_deferred("initialize")

func initialize() -> void:
	Global.tile_map_layers["Ocean"] = %OceanLayer
	Global.tile_map_layers["Fog"] = %FogLayer
	Global.tile_map_layers["DenseFog"] = %DenseFogLayer
	Global.player = player
	Global.ui = %UI
	Global.tile_map_layers["Fog"].show()
	Global.tile_map_layers["DenseFog"].show()
	ambient_light.show()
	monster.caught_player.connect(defeat)


func create_toast_message(message:String, _toast_position: Vector2 = get_local_mouse_position()) -> void:
	if !toast_timer.is_stopped():
		return
	var toast: Label = Global.ui.TOAST_LABEL.instantiate()
	toast.text = message
	Global.ui.toast_message_zone.add_child(toast)
	toast_timer.start()


func defeat() -> void:
	SceneLoader.change_scene_to_resource()
