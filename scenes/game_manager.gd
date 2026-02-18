class_name GameManager extends Node

signal changed_mode(new_mode:Mode)

enum Mode{MOVE, ROTATE, TRAP, SELECT}

@onready var move_path: Path2D = $"../MovePath"
@onready var ocean_map: TileMapLayer = $"../OceanLayer"
@onready var fog_map: TileMapLayer = $"../FogLayer"
@onready var player: Player = get_tree().get_nodes_in_group("player")[0]
@onready var tile_maps: Array[Node] = get_tree().get_nodes_in_group("tile_maps")
@onready var action_buttons: Array[Button] = [%MoveButton, %RotateButton, %TrapButton]

var mode: Mode = Mode.MOVE

func _ready() -> void:
	action_buttons[0].pressed.connect(_move)
	for map: Map in tile_maps:
		map.clicked.connect(_set_path_points)
		

func _move() -> void:
	print("move started")
	await player._move_along_path()
	print("move finished")
	# reset curve start and progress ratio
	print("set points", move_path.curve.get_point_position(0), move_path.curve.get_point_position(1))
	move_path.curve.set_point_position(0,move_path.curve.get_point_position(1))
	print("set points", move_path.curve.get_point_position(0), move_path.curve.get_point_position(1))
	print("progress_ratio", player.progress_ratio)
	player.progress_ratio = 0.0;
	print("progress_ratio", player.progress_ratio)

func _set_path_points(end_point) -> void:
	print("progress_ratio", player.progress_ratio)
	print("end_point", end_point)
	if !player._can_move_to(end_point):
		print("Not enough AP to move there")
		return
	move_path.curve.set_point_position(0,player.global_position)
	move_path.curve.set_point_position(1,end_point)
	%helper.global_position = end_point
	print("set points", move_path.curve.get_point_position(0), move_path.curve.get_point_position(1))

func _is_tile_traversable(clicked_cell) -> bool:
	var data = ocean_map.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("can_traverse")
	else:
		return false

func _on_press_button() -> void:
	action_buttons[0].toggle_mode = true

func _change_mode(new_mode:Mode) -> void:
	print("Changing mode: " + str(new_mode))
	mode = new_mode


func _on_scan_button_pressed() -> void:
	player._scan()
