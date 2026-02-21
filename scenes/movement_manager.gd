extends Node
@onready var game_manager: GameManager = $"../.."
@onready var player: Player = %Player
@onready var move_path: Path2D = $"../../MovePath"
@onready var ocean_layer: TileMapLayer = %OceanLayer
@onready var global_mouse_marker: Polygon2D = %GlobalMouseMarker
@onready var tile_map_cell_marker: Polygon2D = %TileMapCellMarker

var move_path_origin:= Vector2.ZERO

func _ready() -> void:
	move_path.curve.clear_points()
	move_path.curve.add_point(move_path_origin)

func _on_move_request() -> void:
	var current_position: Vector2 = get_cell_position_from_player()
	var destination_position: Vector2 = get_cell_position_from_mouse()
	var destination_cell: Vector2i = get_cell_coords_from_mouse()
	if destination_position == current_position:
		print("Cannot move to current location")
		return
	if !is_tile_traversable(destination_cell):
		game_manager.create_toast_message("Not traversable")
		return
	var ap_cost = player.get_ap_cost(destination_position)
	if player.current_action_points >= player.get_ap_cost(destination_position):
		set_path_destination(destination_position)
		reset_player_progress()
		await player.move_along_path()
		reset_path_origin()
		print("Move completed.")
	else:
		game_manager.create_toast_message("Insufficient AP")


func get_cell_coords_from_mouse() -> Vector2i:
	var cell_coords: Vector2i
	var local_mouse_position: Vector2
	local_mouse_position = ocean_layer.get_local_mouse_position()
	cell_coords = ocean_layer.local_to_map(local_mouse_position) # TileMap coordinates for the selected cell
	return cell_coords


func get_cell_position_from_mouse() -> Vector2:
	var cell_coords: Vector2i = get_cell_coords_from_mouse()
	var local_cell_position: Vector2 = ocean_layer.map_to_local(cell_coords)
	var global_cell_position: Vector2 = ocean_layer.to_global(local_cell_position) # Centered global_position of the selected cell
	return global_cell_position


func get_cell_position_from_player() -> Vector2:
	var cell_coords: Vector2i = player.global_position
	var local_cell_position: Vector2i = ocean_layer.map_to_local(cell_coords)
	var global_cell_position: Vector2 = ocean_layer.to_global(local_cell_position) # Centered global_position of the selected cell
	return global_cell_position


func show_helper_marker(position) -> void:
	global_mouse_marker.global_position = position # Helper debug visual


func is_tile_traversable(clicked_cell) -> bool:
	var data = ocean_layer.get_cell_tile_data(clicked_cell)
	if data:
		return data.get_custom_data("can_traverse")
	else:
		return false


func reset_path_origin() -> void:
	move_path.curve.set_point_position(0,move_path.curve.get_point_position(1))
	move_path.curve.remove_point(1)


func set_path_destination(destination) -> void:
	move_path.curve.add_point(destination)


func reset_player_progress() -> void:
	player.progress_ratio = 0.0 
