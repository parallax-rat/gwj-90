class_name TurnManager extends Node

signal start_turn(turn_number:int, current_turn:int)
signal start_player_turn

@onready var current_turn_label: Label = %CurrentTurnLabel
@onready var finish_turn_button: Button = %FinishTurnButton
@onready var player: Player = %Player

enum State {READY, BUSY}
enum Turn {PLAYER, ENVIRONMENT}

var current_state:int = State.READY
var current_turn:int = Turn.PLAYER
var turn_number: int = 1

func _ready() -> void:
	print("turn manager ready")
	player.action_points_changed.connect(on_action_points_changed)
	Global.finished_turn.connect(_on_end_turn)
	
func on_action_points_changed(ap:int):
	print("turnmanager checking ap ", ap)
	if ap <= 0:
		_end_turn()
	
func _on_end_turn(who:Global.Actors):
	print("got signal")
	print(who)
	print(Global.Actors.PLAYER)
	if who == Global.Actors.PLAYER:
		print("Player ending turn")
	else:
		print("Environment ending turn")
	if current_state == State.READY:
		_end_turn()

func _end_turn():
	if current_turn == Turn.PLAYER:
		current_turn = Turn.ENVIRONMENT
		print("setting turn text")
		current_turn_label.text = "Waiting"
	elif current_turn == Turn.ENVIRONMENT:
		current_turn = Turn.PLAYER
		current_turn_label.text = "PLAYER"
		start_player_turn.emit()
	
	turn_number+=1
	start_turn.emit(turn_number, current_turn)
