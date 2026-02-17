class_name Player
extends Node2D

signal action_points_changed(value)

@onready var scan_range: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal
@onready var sprite: Sprite2D = $Sprite2D

var move_tween: Tween
var current_action_points: int:
	set(value):
		current_action_points = value
		action_points_changed.emit(current_action_points)
	get:
		return current_action_points

@export var starting_action_points: int = 1

@export var move_ap_cost: int = 1
@export var rotate_ap_cost: int = 1
@export var trap_ap_cost: int = 1
@export var new_turn_ap_refresh: int = 1

func _ready() -> void:
	current_action_points = starting_action_points

func _can_move_to(target:Vector2, current_occupied_cell) -> bool:
	var distance = global_position.distance_to(target)
	var ap_cost = distance / Global.HEX_SIZE
	if ap_cost > current_action_points or distance < 32.0:
		return false
	else:
		return true

func _move(target:Vector2) -> void:
	if move_tween:
		move_tween.kill()
	move_tween = create_tween()
	move_tween.tween_property(self, "position", target, 0.5).set_ease(Tween.EASE_IN_OUT)
	current_action_points -= 1

func _rotate(target:Vector2) -> void:
	sprite.look_at(target)
	#var t = create_tween()
	#t.tween_property(sprite,"rotation",target,0.1).set_ease(Tween.EASE_IN_OUT)

func _place_trap(grid_space:GridSpace):
	print("DEBUG: Placing trap at " + str(snapped(grid_space.global_position,1)))
