class_name TurnManager extends Node

signal start_turn(turn_number:int, current_turn:int)

@onready var current_turn_label: Label = %CurrentTurnLabel
@onready var finish_turn_button: Button = %FinishTurnBtn

enum State {READY, BUSY}
enum Turn {PLAYER, ENVIRONMENT}

var current_state:int = State.READY
var current_turn:int = Turn.ENVIRONMENT
var turn_number: int = 1

func _ready() -> void:
	print("turn manager ready")
	finish_turn_button.pressed.connect(_on_finish_turn_btn)
	_finish_turn()
	
func _on_finish_turn_btn():
	print("pressed btn")
	if current_state == State.READY:
		_finish_turn()

func _finish_turn():
	if current_turn == Turn.PLAYER:
		current_turn = Turn.ENVIRONMENT
		current_turn_label.text = "ENVIRONMENT"
		
	if current_turn == Turn.ENVIRONMENT:
		current_turn = Turn.PLAYER
		current_turn_label.text = "PLAYER"
	
	turn_number+=1
	start_turn.emit(turn_number, current_turn)
