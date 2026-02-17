class_name Player
extends Node2D

@onready var scan_range: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal

var move_tween: Tween

@export var action_points: int = 1

func _move(target:Vector2) -> void:
	if move_tween:
		move_tween.kill()
	move_tween = create_tween()
	move_tween.tween_property(self, "position", target, 1.0).set_ease(Tween.EASE_IN_OUT)

func _rotate(target:Vector2) -> void:
	var target_rotation = snapped((target - global_position).angle(),45)
	var t = create_tween()
	t.tween_property(self,"rotation",target_rotation,0.25).set_ease(Tween.EASE_IN_OUT)

func _place_trap(grid_space:GridSpace):
	print("DEBUG: Placing trap at " + str(snapped(grid_space.global_position,1)))
