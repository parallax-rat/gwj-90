extends Node2D

@onready var ocean_layer: TileMapLayer = %OceanLayer
@onready var player: Player = Global.player
var astar_grid: AStarGrid2D


func _physics_process(delta: float) -> void:
	pass
