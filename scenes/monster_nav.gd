class_name Monster extends CharacterBody2D

@onready var movement_manager: Node = $"../Managers/MovementManager"
@onready var ocean_layer: TileMapLayer = %OceanLayer
@onready var player: Player = Global.player
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var player_move_counter: int = 0
var player_moves_to_wait_for: int = 2
var player_cell: Vector2i
var player_position: Vector2
var monster_cell: Vector2i

func _ready() -> void:
	monster_cell = world_to_cell(global_position)
	global_position = cell_to_world(monster_cell)
	movement_manager.player_move_finished.connect(_on_player_moved)


func _on_player_moved(new_player_cell:Vector2i, new_player_position:Vector2) -> void:
	player_cell = new_player_cell
	player_position = new_player_position
	player_move_counter += 1
	if player_move_counter < player_moves_to_wait_for:
		return
	player_move_counter = 0
	time_to_move()


func time_to_move():
	var player_cell: Vector2i = world_to_cell(player_position)

func world_to_cell(world_position: Vector2) -> Vector2i:
	return ocean_layer.local_to_map(ocean_layer.to_local(world_position))

func cell_to_world(cell: Vector2i) -> Vector2:
	return ocean_layer.to_global(ocean_layer.map_to_local(cell))
