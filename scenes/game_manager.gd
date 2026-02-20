class_name GameManager extends Node2D

@onready var move_path: Path2D = $MovePath
@onready var ocean_map: TileMapLayer = %OceanLayer
@onready var fog_map: TileMapLayer = %FogLayer
@onready var player: Player = get_tree().get_nodes_in_group("player")[0]
@onready var movement_manager: Node = $Managers/MovementManager


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		print("Unhandled Input @ ", name)
		match Global.current_action:
			Global.Actions.MOVE:
				print("Move action Requested @ ", name)
				movement_manager._on_move_request()
