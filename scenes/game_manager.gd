extends Node2D

signal changed_mode(new_mode:Mode)

enum Mode{MOVE, ROTATE, TRAP, SELECT}

@onready var map: TileMapLayer = $"../TileMapLayer"
@onready var player: Player = get_tree().get_nodes_in_group("player")[0]
@onready var action_buttons: Array[Button] = [%MoveButton, %RotateButton, %TrapButton]

var mode: Mode = Mode.MOVE

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("select") and mode == Mode.MOVE:
		print("move mode enabled")
		var tile_coords = map.local_to_map(map.to_local(get_global_mouse_position()))
		print(tile_coords)
		
		if _is_tile_traversable(tile_coords):
			var target_world = map.map_to_world(tile_coords)
			player._rotate(target_world)
			player._move(target_world)

#region movement

func _is_tile_traversable(tile_coords:Vector2i) -> bool:
	var data = map.get_cell_tile_data(tile_coords)
	if data == null:
		return false
	return data.get_custom_data_by_layer_id(0)

#endregion

func _on_press_button() -> void:
	action_buttons[0].toggle_mode = true

func _change_mode(new_mode:Mode) -> void:
	print("Changing mode: " + str(new_mode))
	mode = new_mode
