extends Node

const HEX_SIZE = 64

enum Action{MOVE, ROTATE, TRAP, SELECT}

@onready var buttons: Array[Node] = get_tree().get_nodes_in_group("buttons")

var current_action: Action = Action.MOVE

func _select_action(action:Action) -> void:
	print("Current action: " + str(action))
	current_action = action
