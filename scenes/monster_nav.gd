class_name Monster extends Node2D

@onready var game_manager: GameManager = %GameManager
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var agent: NavigationAgent2D
@export var area: Area2D

var player_caught: bool = false
var player_ap_counter: int = 0:
	set(value):
		player_ap_counter = value
		prints("Player AP Counter for Monster:",player_ap_counter)
var player_ap_to_wait_for: int = 2


@export var moves_per_action: int = 1

func _ready() -> void:
	call_deferred("connect_nodes")


func connect_nodes() -> void:
	Global.player.action_points_change.connect(_on_player_ap_changed)


func _on_player_ap_changed(amount) -> void:
	var val = abs(amount)
	player_ap_counter += val
	if player_ap_counter >= player_ap_to_wait_for:
		player_ap_counter = 0
		move()


func submerge() -> void:
	sprite.play("GoBelow")
	await sprite.animation_finished


func emerge() -> void:
	sprite.play("GoAbove")
	await sprite.animation_finished


func move():
	if player_caught:
		return
	await submerge()
	var start_cell: Vector2i = GridUtils.get_cell_coords_from_world_position(Global.tile_map_layers["Ocean"],global_position)
	var path_cells: Array[Vector2i] = _get_path_cells_to_target(Global.get_player_cell_coords())
	if path_cells.is_empty():
		return
	if path_cells[0] == start_cell:
		path_cells.remove_at(0)
	var steps: int = min(moves_per_action, path_cells.size())
	var destination_cell: Vector2i = path_cells[steps - 1]
	
	global_position =  _cell_center_global(destination_cell)
	await get_tree().create_timer(1).timeout
	await emerge()


func _get_path_cells_to_target(target_cell: Vector2i) -> Array[Vector2i]:
	var target_pos: Vector2 = Global.get_player_cell_position()

	agent.target_position = target_pos
	agent.get_next_path_position()

	var pts: PackedVector2Array = agent.get_current_navigation_path()
	return _path_points_to_cells(pts)

func _path_points_to_cells(points: PackedVector2Array) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var last: Vector2i = Vector2i(2147483647, 2147483647)

	for p: Vector2 in points:
		var cell: Vector2i = Global.tile_map_layers["Ocean"].local_to_map(Global.tile_map_layers["Ocean"].to_local(p))
		if cell != last:
			out.append(cell)
			last = cell

	return out


func _cell_center_global(cell: Vector2i) -> Vector2:
	return Global.tile_map_layers["Ocean"].to_global(Global.tile_map_layers["Ocean"].map_to_local(cell))


func _on_monster_area_area_entered(area: Area2D) -> void:
	game_manager.create_toast_message("Monster got ya")
	player_caught = true
