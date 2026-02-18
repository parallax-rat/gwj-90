extends Node
#region Buttons

var player: Player
@onready var move_button: Button = %MoveButton
@onready var rotate_button: Button = %RotateButton
@onready var trap_button: Button = %TrapButton
@onready var current_ap_label: Label = %CurrentAPLabel

#endregion


func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	player.action_points_changed.connect(_update_ap_label)

func _update_ap_label(new_ap_value:int) -> void:
	current_ap_label.text = str(new_ap_value)

func _update_mode_name(new_mode:int) -> void:
	pass
