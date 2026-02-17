extends Node
#region Buttons

@onready var move_button: Button = %MoveButton
@onready var rotate_button: Button = %RotateButton
@onready var trap_button: Button = %TrapButton

#endregion

#region labels

@onready var current_mode_label: Label = %CurrentModeLabel

#endregion


func _update_mode_name(new_mode:int) -> void:
	pass
