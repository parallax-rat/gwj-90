class_name MovementManager extends Node

@onready var game_manager: GameManager = %GameManager
@onready var player: Player = %Player
@onready var ocean_layer: TileMapLayer = %OceanLayer


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("select"):
		if player.moving or get_hex_distance(Global.get_mouse_cell_position(),Global.get_player_cell_position()) > Global.HEX_SIZE:
			return
		_on_move_request(Global.get_mouse_cell_coords(), Global.get_mouse_cell_position())



func _on_move_request(coords: Vector2i, destination:Vector2) -> void:
	if tile_is_traversable(coords) and player.current_action_points >= 1:
		player.move(destination)


func get_cell_coords_from_mouse() -> Vector2i:
	var cell_coords: Vector2i
	var local_mouse_position: Vector2
	local_mouse_position = ocean_layer.get_local_mouse_position()
	cell_coords = ocean_layer.local_to_map(local_mouse_position) # TileMap coordinates for the selected cell
	return cell_coords


func get_cell_coords_from_player() -> Vector2i:
	var cell_coords: Vector2i
	var player_position: Vector2 = %Player.global_position
	cell_coords = ocean_layer.local_to_map(player_position) # TileMap coordinates for the player
	return cell_coords


func get_cell_position_from_mouse() -> Vector2:
	var cell_coords: Vector2i = get_cell_coords_from_mouse()
	var local_cell_position: Vector2 = ocean_layer.map_to_local(cell_coords)
	var global_cell_position: Vector2 = ocean_layer.to_global(local_cell_position) # Centered global_position of the selected cell
	return global_cell_position


func get_cell_position_from_player() -> Vector2:
	var cell_coords: Vector2i = get_cell_coords_from_player()
	var local_cell_position: Vector2i = ocean_layer.map_to_local(cell_coords)
	var global_cell_position: Vector2 = ocean_layer.to_global(local_cell_position) # Centered global_position of the player
	return global_cell_position


static func get_hex_distance(a: Vector2i, b: Vector2i) -> int:
	var ac: Vector3i = _odd_r_to_cube(a)
	var bc: Vector3i = _odd_r_to_cube(b)
	return _cube_distance(ac, bc)


static func _odd_r_to_cube(h: Vector2i) -> Vector3i:
	var q: int = h.x
	var r: int = h.y
	var x: int = q - ((r - (r & 1)) / 2)
	var z: int = r
	var y: int = -x - z
	return Vector3i(x, y, z)


static func _cube_distance(a: Vector3i, b: Vector3i) -> int:
	var dx: int = abs(a.x - b.x)
	var dy: int = abs(a.y - b.y)
	var dz: int = abs(a.z - b.z)
	return (dx + dy + dz) / 2


func tile_is_traversable(_coords:Vector2i) -> bool:
	if Global.get_player_cell_coords() == _coords:
		return false
	var data: TileData = Global.tile_map_layers["Ocean"].get_cell_tile_data(_coords)
	if data:
		return data.get_custom_data("can_traverse")
	else:
		return false
