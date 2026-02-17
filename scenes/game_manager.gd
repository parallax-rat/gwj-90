extends Node2D

signal changed_mode(new_mode:Mode)

enum Mode{MOVE, ROTATE, TRAP, SELECT}

@onready var map: TileMapLayer = $"../TileMapLayer"
@onready var player: Player = get_tree().get_nodes_in_group("player")[0]
@onready var action_buttons: Array[Button] = [%MoveButton, %RotateButton, %TrapButton]

var mode: Mode = Mode.MOVE

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("select") and mode == Mode.MOVE:
		var clicked_cell = map.local_to_map(map.get_local_mouse_position())
		var current_occupied_cell = map.local_to_map(to_local(player.global_position))
		print(current_occupied_cell)
		if _is_tile_traversable(clicked_cell):
			var half_tile = Global.HEX_SIZE / 2
			var cell_move_target = map.map_to_local(clicked_cell) - Vector2(half_tile,half_tile)
			cell_move_target = to_global(cell_move_target)
			if !player._can_move_to(cell_move_target, current_occupied_cell):
				print("Not enough AP to move there")
				return
			player._rotate(cell_move_target)
			player._move(cell_move_target)

func _is_tile_traversable(clicked_cell) -> bool:
	var data = map.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("can_traverse")
	else:
		return false

func _on_press_button() -> void:
	action_buttons[0].toggle_mode = true

func _change_mode(new_mode:Mode) -> void:
	print("Changing mode: " + str(new_mode))
	mode = new_mode
