class_name Player
extends Node2D

signal action_points_change(amount)
signal completed_a_move()

@onready var game_manager: GameManager = %GameManager
@onready var scan_area: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal
@onready var sprite: Sprite2D = $Sprite2D
@onready var map_manager: MapManager = %MapManager
@onready var start_pos: Node2D = %StartPos

@export var starting_action_points: int = 10
@export var movement_time_duration: float = 1
@export var maximum_action_points: int = 10
@export_file("*.tscn") var ending_scene_path : String

var moving: bool = false
var current_action_points: int:
	set(value):
		current_action_points = value
		Global.ui.action_points_value.text = str(current_action_points)
	get:
		return current_action_points


func _ready() -> void:
	global_position = start_pos.global_position
	call_deferred("connect_to_external")


func connect_to_external() -> void:
	Global.ui.scan_button.pressed.connect(scan)
	Global.ui.rest_button.pressed.connect(rest)
	current_action_points = starting_action_points


func reduce_action_points(amount:int) -> void:
	current_action_points -= amount
	action_points_change.emit(amount)


func increase_action_points(amount:int) -> void:
	current_action_points += amount
	action_points_change.emit(amount)


func move(destination: Vector2) -> void:
	moving = true
	look_at(destination)
	Global.moves += 1
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(self, "global_position", destination, movement_time_duration).set_ease(Tween.EASE_IN_OUT)
	await move_tween.finished
	reduce_action_points(1)
	moving = false
	completed_a_move.emit()


func scan() -> void:
	if current_action_points == 0:
		game_manager.create_toast_message("No remaining action points.")
		return
	Global.scans += 1
	var fog_in_range: Array[Area2D] = $ScanRange.get_overlapping_areas()
	var _fog_scanned:int = 0
	for fog in fog_in_range:
		if current_action_points < 1:
			break
		clear_fog(fog)
		_fog_scanned += 1
		Global.fog_cleared += 1
		if _fog_scanned % 2 == 0:  # <- 1 AP for every 2 hexes cleared
			reduce_action_points(1)
	game_manager.create_toast_message("Scanned " + str(_fog_scanned) + " fog hexes. -")


func rest() -> void:
	Global.times_rested += 1
	game_manager.create_toast_message("Restored 2 action points by resting.")
	increase_action_points(2)


func clear_fog(area: Area2D) -> void:
	map_manager.update_mapped_fog(area)
	var tween = get_tree().create_tween()
	tween.tween_property(area,"modulate:a",0.0,0.5)
	await tween.finished
	if area:
		area.queue_free()


func _on_passive_fog_reveal_area_entered(area: Area2D) -> void:
	if area.name == "GoalDock":
		if moving:
			await completed_a_move
		load_ending_scene()
	else:
		clear_fog(area)


func load_ending_scene() -> void:
	global_position = start_pos.global_position
	SceneLoader.load_scene("res://scenes/end_screen.tscn")
