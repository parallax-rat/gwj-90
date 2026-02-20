class_name Player
extends PathFollow2D

signal action_points_changed(value)

@onready var scan_area: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal
@onready var sprite: Sprite2D = $Sprite2D
@onready var scan_btn:Button = %ScanButton


var current_action_points: float:
	set(value):
		current_action_points = value
		action_points_changed.emit(current_action_points)
	get:
		return current_action_points

@export var starting_action_points: float = 2
@export var movement_time_duration: float = 1.0
@export var rotate_ap_cost: float = 1
@export var trap_ap_cost: float = 1
@export var new_turn_ap_refresh: float = 2

func _ready() -> void:
	scan_btn.pressed.connect(scan)
	current_action_points = starting_action_points

func get_ap_cost(destination:Vector2) -> float:
	var distance = position.distance_to(destination)
	print(distance)
	var ap_cost = floor(distance / Global.HEX_SIZE_I)
	print("AP Cost: ", ap_cost)
	return ap_cost

func move_along_path() -> void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(self, "progress_ratio", 1.0, movement_time_duration).set_ease(Tween.EASE_IN_OUT)
	await move_tween.finished
	current_action_points -= 1


func scan() -> void:
	var detected_areas = scan_area.get_overlapping_bodies()
	for fog in detected_areas:
		clear_fog(fog)


func clear_fog(area) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(area,"modulate:a",0.0,0.5)
	await tween.finished
	if area:
		area.queue_free()


func _on_passive_fog_reveal_area_entered(area: Area2D) -> void:
	print("FOG AREA",area)
	clear_fog(area)
