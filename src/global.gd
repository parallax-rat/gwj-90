extends Node

signal finished_turn(who:Actors)

const HEX_SIZE_I = 64
const HEX_SIZE_V = Vector2(HEX_SIZE_I,HEX_SIZE_I)

enum Actors{PLAYER, ENVIRONMENT}
enum Actions{NONE, ROTATE, MOVE, SCAN, PLACE_TRAP, FINISH_TURN}

var current_scene: Node
var player: Player
var scan_button: Button
var rest_button: Button
var current_action: Actions = Actions.MOVE


func connect_button_group() -> void:
	current_scene = get_tree().current_scene
	scan_button =  current_scene.get_node("%ScanButton")
	rest_button =  current_scene.get_node("%RestButton")
	player = current_scene.get_node("%Player")
	scan_button.pressed.connect(_on_scan_button_pressed)
	rest_button.pressed.connect(_on_rest_button_pressed)


func _on_scan_button_pressed() -> void:
	player.scan()


func _on_rest_button_pressed() -> void:
	player.rest()


func _on_button_group_pressed(button: BaseButton) -> void:
	match button:
		#null_button:
			#_set_action(Actions.NONE)
		#move_button:
			#if current_action == Actions.MOVE:
				#_set_action(Actions.NONE)
			#else:
				#_set_action(Actions.MOVE)
		scan_button:
			_set_action(Actions.SCAN)
		rest_button:
			_set_action(Actions.PLACE_TRAP)


func _set_action(action: Actions) -> void:
	if current_action == action:
		return
	current_action = action
	
	print(current_action)
	match current_action:
		Actions.FINISH_TURN:
			finished_turn.emit(Actors.PLAYER)
			print("Sent signal")
