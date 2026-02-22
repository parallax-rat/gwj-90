class_name MoveComponent extends Node

@onready var entity = self.get_parent()
@onready var move_path = self.get_parent().get_parent()
@onready var ocean_layer: TileMapLayer = %OceanLayer
#@onready var global_mouse_marker: Polygon2D = %GlobalMouseMarker
#@onready var tile_map_cell_marker: Polygon2D = %TileMapCellMarker

var move_path_origin:= Vector2.ZERO

func _ready() -> void:
	pass
	#move_path.curve.clear_points()
	#move_path.curve.add_point(move_path_origin)

func move(from: Vector2, to: Vector2) -> void:
	var current_position: Vector2 = from
	var destination_position: Vector2 = to
	var destination_cell: Vector2i = get_cell_coords_from_pos(to)
	prints("Move Destination:", destination_position, destination_cell)
	if destination_position == current_position:
		print("Cannot move to current location")
		return
	if !is_tile_traversable(destination_cell):
		print("Not traversable")
		return
	print("Current AP: ",entity.current_action_points)
	if entity.current_action_points >= entity.get_ap_cost(destination_position):
		set_path_destination(destination_position)
		reset_entity_progress()
		await entity.move_along_path()
		reset_path_origin()
		print("Move completed.")


func get_cell_coords_from_pos(pos: Vector2) -> Vector2i:
	var cell_coords: Vector2i
	var local_position: Vector2
	local_position = ocean_layer.to_local(pos)
	cell_coords = ocean_layer.local_to_map(local_position) # TileMap coordinates for the selected cell
	return cell_coords


func get_cell_position_from_pos(pos: Vector2) -> Vector2:
	var cell_coords: Vector2i = get_cell_coords_from_pos(pos)
	var local_cell_position: Vector2 = ocean_layer.map_to_local(cell_coords)
	var global_cell_position: Vector2 = ocean_layer.to_global(local_cell_position) # Centered global_position of the selected cell
	return global_cell_position

#func show_helper_marker(position) -> void:
	#global_mouse_marker.global_position = position # Helper debug visual

func is_tile_traversable(cell: Vector2i) -> bool:
	var data = ocean_layer.get_cell_tile_data(cell)
	if data:
		return data.get_custom_data("can_traverse")
	else:
		return false


func reset_path_origin() -> void:
	move_path.curve.set_point_position(0,move_path.curve.get_point_position(1))
	move_path.curve.remove_point(1)


func set_path_destination(destination) -> void:
	move_path.curve.add_point(destination)


func reset_entity_progress() -> void:
	entity.progress_ratio = 0.0 
