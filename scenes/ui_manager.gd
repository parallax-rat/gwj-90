extends Node
#region Buttons

@onready var player: Player = %Player
#@onready var trap_button: Button = %TrapButton
@onready var current_ap_label: Label = %CurrentAPLabel

#endregion


#func _ready() -> void:
	#player.action_points_change.connect(_update_ap_label)

#func _update_ap_label(new_ap_value:int) -> void:
	#current_ap_label.text = str(new_ap_value)

#func _update_mode_name(new_mode:int) -> void:
	#pass
