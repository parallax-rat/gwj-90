extends Node

@onready var player: Player = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_add_ap"):
		player.current_action_points += 1
