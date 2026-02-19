class_name Player
extends PathFollow2D

signal action_points_changed(value)

@onready var scan_area: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var scan_btn:Button = %ScanButton


var move_tween: Tween
var current_action_points: int:
	set(value):
		current_action_points = value
		action_points_changed.emit(current_action_points)
	get:
		return current_action_points

@export var starting_action_points: int = 1
@export var movement_time_duration: float = 1.0
@export var move_ap_cost: int = 1
@export var rotate_ap_cost: int = 1
@export var trap_ap_cost: int = 1
@export var new_turn_ap_refresh: int = 1

var is_moving = false

func _ready() -> void:
	scan_btn.pressed.connect(_scan)
	current_action_points = starting_action_points

func _can_move_to(target:Vector2) -> bool:
	var distance = position.distance_to(target)
	var ap_cost = floor(distance / Global.HEX_SIZE)
	print(ap_cost)
	if ap_cost > current_action_points or distance < 32.0:
		return false
	else:
		return true

func _move_along_path() -> void:
	if is_moving:
		return
	#if move_tween:
		#move_tween.kill()
	is_moving = true
	progress_ratio = 0.0
	move_tween = create_tween()
	move_tween.tween_property(self, "progress_ratio", 1.0, movement_time_duration).set_ease(Tween.EASE_IN_OUT)
	await move_tween.finished
	move_tween.kill()
	current_action_points -= 1
	is_moving = false


func _scan() -> void:
	var detected_areas = scan_area.get_overlapping_areas()
	for fog in detected_areas:
		clear_fog(fog)


func _place_trap(grid_space:GridSpace):
	print("DEBUG: Placing trap at " + str(snapped(grid_space.global_position,1)))


func clear_fog(area) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(area,"modulate:a",0.0,0.5)
	await tween.finished
	if area:
		area.queue_free()


func _on_passive_fog_reveal_area_entered(area: Area2D) -> void:
	clear_fog(area)
