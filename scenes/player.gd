class_name Player
extends PathFollow2D

signal action_points_change(amount)
signal completed_a_move()

@onready var game_manager: GameManager = $"../.."
@onready var scan_area: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal
@onready var sprite: Sprite2D = $Sprite2D
@onready var scan_btn: Button = %ScanButton
@onready var rest_btn: Button = %RestButton
@onready var ap_label: Label = %CurrentAPLabel
@onready var map_manager: MapManager = $"../../Managers/MapManager"
@onready var start_pos: Node2D = %StartPos

@export var starting_action_points: int = 10
@export var movement_time_duration: float = 1
@export var maximum_action_points: int = 10
@export_file("*.tscn") var ending_scene_path : String

var current_cell: Vector2i
var target_cell: Vector2i
var move_points: Array

var current_action_points: int:
	set(value):
		current_action_points = value
		action_points_change.emit(current_action_points)
		ap_label.text = str(current_action_points)
	get:
		return current_action_points

func _ready() -> void:
	scan_btn.pressed.connect(scan)
	rest_btn.pressed.connect(rest)
	#action_points_change.connect(_on_action_points_change)
	current_action_points = starting_action_points
	global_position = start_pos.global_position


func reduce_action_points(amount:int) -> void:
	current_action_points -= amount


func increase_action_points(amount:int) -> void:
	current_action_points += amount


func get_ap_cost(destination:Vector2) -> float:
	var distance = position.distance_to(destination)
	print(distance)
	var ap_cost = floor(distance / Global.HEX_SIZE_I)
	print("AP Cost: ", ap_cost)
	return clampf(ap_cost,1.0,99.0)

func move_along_path() -> void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(self, "progress_ratio", 1.0, movement_time_duration).set_ease(Tween.EASE_IN_OUT)
	await move_tween.finished
	completed_a_move.emit()
	reduce_action_points(1)
	

func scan() -> void:
	if current_action_points == 0:
		game_manager.create_toast_message("Must rest first..")
		return
	
	Global.scans += 1
	var fog_in_range: Array[Area2D] = $ScanRange.get_overlapping_areas()
	var cleared_fog: int
	for fog in fog_in_range:
		if current_action_points < 1:
			break
		reduce_action_points(1)
		clear_fog(fog)
		cleared_fog += 1
	game_manager.create_toast_message("Scanned " + str(cleared_fog) + " fog hexes..")


func rest() -> void:
	Global.times_rested += 1
	game_manager.create_toast_message("Restored 2 action points..")
	increase_action_points(2)


func clear_fog(area: Area2D) -> void:
	map_manager.update_mapped_fog(area)
	var tween = get_tree().create_tween()
	tween.tween_property(area,"modulate:a",0.0,0.5)
	await tween.finished
	if area:
		area.queue_free()


func _on_passive_fog_reveal_area_entered(area: Area2D) -> void:
	print("FOG AREA",area)
	if area.name == "GoalDock":
		print("end game")
		load_ending_scene()
	else:
		clear_fog(area)
	
func load_ending_scene() -> void:
	global_position = start_pos.global_position
	SceneLoader.load_scene("res://scenes/end_screen.tscn")
