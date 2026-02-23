class_name GameManager extends Node2D

@onready var player: Player = %Player
@onready var movement_manager: MovementManager = %MovementManager
@onready var toast_timer: Timer = %ToastTimer
@onready var ambient_light: CanvasModulate = %AmbientLight


func _ready() -> void:
	Global.connect_scenes()
	Global.tile_map_layers["Fog"].show()
	Global.tile_map_layers["DenseFog"].show()
	ambient_light.show()


func create_toast_message(message:String, _toast_position: Vector2 = get_local_mouse_position()) -> void:
	if !toast_timer.is_stopped():
		return
	var toast: Label = Global.ui.TOAST_LABEL.instantiate()
	toast.text = message
	Global.ui.toast_message_zone.add_child(toast)
	toast_timer.start()
