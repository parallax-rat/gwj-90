extends Control

@onready var mapped: Label = $StatsMargin/Panel/MarginContainer/VBoxContainer/StatsVbox/Mapped/Value
@onready var moves: Label = $StatsMargin/Panel/MarginContainer/VBoxContainer/StatsVbox/Moves/Value
@onready var scans: Label = $StatsMargin/Panel/MarginContainer/VBoxContainer/StatsVbox/Scans/Value
@onready var rested: Label = $StatsMargin/Panel/MarginContainer/VBoxContainer/StatsVbox/Rested/Value
@onready var score: Label = $StatsMargin/Panel/MarginContainer/VBoxContainer/StatsVbox/Score/Value
@onready var play_again_btn: Button = $StatsMargin/Panel/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/PlayAgain

func _ready() -> void:
	mapped.text = str(int(Global.mapped))+'%'
	moves.text = str(Global.moves)
	scans.text = str(Global.scans)
	rested.text = str(Global.times_rested)
	score.text = str(int(calculate_score()))
	play_again_btn.pressed.connect(play_again)

func calculate_score():
	#TODO make a good calculation
	var score: float = 0.0
	score += Global.mapped
	score -= Global.moves
	score -= Global.scans
	score -= Global.times_rested
	return score

func play_again():
	SceneLoader.load_scene("res://scenes/test.tscn")
