extends Node2D

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
	for map: Map in tile_maps:
		map.clicked.connect(_move)
		

func _move(cell_coords) -> void:
		if !player._can_move_to(cell_coords):
			print("Not enough AP to move there")
			return
		_set_path_points(cell_coords)
		player._move_along_path(cell_coords)

func _set_path_points(end_point) -> void:
	move_path.curve.set_point_position(0,player.global_position)
	move_path.curve.set_point_position(1,end_point)

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
