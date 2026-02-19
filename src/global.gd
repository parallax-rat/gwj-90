extends Node

signal finished_turn(who:Actors)

const HEX_SIZE_I = 64
const HEX_SIZE_V = Vector2(HEX_SIZE_I,HEX_SIZE_I)

enum Actors{PLAYER, ENVIRONMENT}
enum Actions{NONE, ROTATE, MOVE, SCAN, PLACE_TRAP, FINISH_TURN}

@onready var current_scene: Node = get_tree().current_scene
@onready var null_button: Button = current_scene.get_node("%NullButton")
@onready var rotate_button: Button =  current_scene.get_node("%RotateButton")
@onready var move_button: Button =  current_scene.get_node("%MoveButton")
@onready var scan_button: Button =  current_scene.get_node("%ScanButton")
@onready var trap_button: Button =  current_scene.get_node("%TrapButton")
@onready var finish_button: Button =  current_scene.get_node("%FinishTurnButton")
@onready var button_group: ButtonGroup = null_button.button_group

var current_action: Actions = Actions.MOVE

func _ready() -> void:
	button_group.pressed.connect(_on_button_group_pressed)
	null_button.set_pressed(true)

func _on_button_group_pressed(button: BaseButton) -> void:
	match button:
		null_button:
			_set_action(Actions.NONE)
		rotate_button:
			_set_action(Actions.ROTATE)
		move_button:
			_set_action(Actions.MOVE)
		scan_button:
			_set_action(Actions.SCAN)
		trap_button:
			_set_action(Actions.PLACE_TRAP)
		finish_button:
			_set_action(Actions.FINISH_TURN)


func _set_action(action: Actions) -> void:
	if current_action == action:
		return
	
	current_action = action
	
	print(current_action)
	match current_action:
		Actions.FINISH_TURN:
			finished_turn.emit(Actors.PLAYER)
			print("Sent signal")
