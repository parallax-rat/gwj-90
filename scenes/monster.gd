class_name Actor extends PathFollow2D

signal action_points_changed(value)

@onready var move_component: MoveComponent = $MoveComponent

@export var me: int = 2
@export var starting_action_points: int = 4
@export var movement_time_duration: float = 1.0
@export var new_turn_ap_refresh: int = 2

var _ap: int = starting_action_points
var current_action_points: int = _ap:
	set(value):
		_ap = value
		action_points_changed.emit(_ap)
	get:
		return _ap
	
func _on_start_actor_turn(turn_number: int, current_turn:int) -> void:
	if me == current_turn:
		current_action_points += new_turn_ap_refresh
		# check for collitions with trap
		# if trap consume ap and quefree trap
		# fade out monster goes under water
		# monster moves
		await move_component.move(global_position, global_position+Vector2(0, 1))
		# fade in monster rises up to surface
		# check for collission with player
		# end turn

func get_ap_cost(destination:Vector2) -> float:
	var distance = position.distance_to(destination)
	var ap_cost = floor(distance / Global.HEX_SIZE_I)
	return clampf(ap_cost,1.0,99.0)

func move_along_path() -> void:
	var move_tween = get_tree().create_tween()
	move_tween.tween_property(self, "progress_ratio", 1.0, movement_time_duration).set_ease(Tween.EASE_IN_OUT)
	await move_tween.finished
	current_action_points -= 1
