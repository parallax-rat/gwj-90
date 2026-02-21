class_name GameManager extends Node2D

const TOAST_LABEL = preload("uid://cxi7x643863a0")

@onready var move_path: Path2D = $MovePath
@onready var ocean_map: TileMapLayer = %OceanLayer
@onready var fog_map: TileMapLayer = %FogLayer
@onready var dense_fog: TileMapLayer = $DenseFog
@onready var player: Player = get_tree().get_nodes_in_group("player")[0]
@onready var movement_manager: Node = $Managers/MovementManager
@onready var toast_timer: Timer = $ToastTimer
@onready var ui: CanvasLayer = %UI
@onready var canvas_modulate: CanvasModulate = $CanvasModulate


func _ready() -> void:
	Global.connect_button_group()
	call_deferred("initialize_for_play")
	fog_map.show()
	dense_fog.show()
	canvas_modulate.show()


func initialize_for_play() -> void:
	TurnManager.initialize_for_play()


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		print("Unhandled Input @ ", name)
		match Global.current_action:
			Global.Actions.MOVE:
				print("Move action Requested @ ", name)
				movement_manager._on_move_request()


func create_toast_message(message:String, toast_position: Vector2 = get_local_mouse_position()) -> void:
	print("create toast")
	if !toast_timer.is_stopped():
		return
	var toast: Label = TOAST_LABEL.instantiate()
	toast.text = message
	ui.add_child(toast)
	toast_timer.start()
