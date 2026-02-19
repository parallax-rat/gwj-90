class_name GameManager extends Node2D

@onready var helper: Area2D = %Helper
@onready var move_path: Path2D = $"../MovePath"
@onready var ocean_map: TileMapLayer = $"../OceanLayer"
@onready var fog_map: TileMapLayer = $"../FogLayer"
@onready var player: Player = get_tree().get_nodes_in_group("player")[0]
@onready var tile_maps: Array[Node] = get_tree().get_nodes_in_group("tile_maps")
@onready var action_buttons: Array[Button] = [%MoveButton, %RotateButton, %TrapButton, %ScanButton]


func _ready() -> void:
	#action_buttons[0].pressed.connect(_move)
	#for map: Map in tile_maps:
	#	map.clicked.connect(_set_path_points)
	ocean_map.clicked.connect(_set_path_points)

func _move(end_point) -> void:
	print("move started")
	_set_path_points(end_point)
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
	if !player._can_move_to(end_point):
		return
	var start = player.global_position - Global.HEX_SIZE_V / 2
	end_point = end_point - Global.HEX_SIZE_V / 2
	move_path.curve.set_point_position(0,start)
	move_path.curve.set_point_position(1,end_point)

func _is_tile_traversable(clicked_cell) -> bool:
	var data = ocean_map.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("can_traverse")
	else:
		return false


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		match Global.current_action:
			Global.Actions.MOVE:
				print("Move action - GameManager unhandled input")
				var clicked_cell = ocean_map.local_to_map(get_local_mouse_position())
				if !_is_tile_traversable(clicked_cell):
					return
				var coords = to_global(ocean_map.map_to_local(clicked_cell))
				_set_path_points(coords)
				await player._move_along_path()
				print("move finished")


func _on_press_button() -> void:
	action_buttons[0].toggle_mode = true

func _on_scan_button_pressed() -> void:
	player._scan()
