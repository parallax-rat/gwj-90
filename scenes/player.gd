class_name Player
extends PathFollow2D

signal action_points_changed(value)

@onready var scan_area: Area2D = $ScanRange
@onready var passive_fog_reveal: Area2D = $PassiveFogReveal
@onready var sprite: Sprite2D = $Sprite2D
@onready var scan_btn: Button = %ScanButton
@onready var trap_btn: Button = %TrapButton
@onready var ap_label: Label = %CurrentAPLabel
@onready var turn_manager: TurnManager = %TurnManager
@onready var map_manager: MapManager = $"../../Managers/MapManager"

@export var starting_action_points: int = 4
@export var movement_time_duration: float = 1.0
@export var rotate_ap_cost: float = 1
@export var scan_ap_cost: int = 1
@export var trap_ap_cost: int = 1
@export var new_turn_ap_refresh: float = 2

var _ap: int = starting_action_points
var current_action_points: int = _ap:
	set(value):
		_ap = value
		action_points_changed.emit(_ap)
		ap_label.text = str(_ap)
	get:
		return _ap

func _ready() -> void:
	scan_btn.pressed.connect(scan)
	trap_btn.pressed.connect(trap)
	turn_manager.start_player_turn.connect(_on_start_player_turn)
	ap_label.text = str(_ap)
	
func _on_start_player_turn() -> void:
	current_action_points += new_turn_ap_refresh

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
	current_action_points -= 1

func scan() -> void:
	if current_action_points <= 0:
		return
		
	if current_action_points < scan_ap_cost:
		print("not enough ap for scan")
		return
		
	print('scan')
	current_action_points -= scan_ap_cost
	for fog in $ScanRange.get_overlapping_areas():
		clear_fog(fog)
		
func trap() -> void:
	if current_action_points <= 0:
		return
	
	if current_action_points < trap_ap_cost:
		print("not enough ap for trap")
		return
		
	print('trap')
	current_action_points -= trap_ap_cost

func clear_fog(area) -> void:
	map_manager.update_mapped_fog()
	var tween = get_tree().create_tween()
	tween.tween_property(area,"modulate:a",0.0,0.5)
	await tween.finished
	if area:
		area.queue_free()


func _on_passive_fog_reveal_area_entered(area: Area2D) -> void:
	print("FOG AREA",area)
	clear_fog(area)
