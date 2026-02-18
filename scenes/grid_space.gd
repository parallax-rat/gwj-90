class_name GridSpace
extends Node2D

signal hovering(grid_space:GridSpace)
signal stopped_hovering(grid_space:GridSpace)
signal selected(grid_space:GridSpace)

const highlight_fade_time: float = 0.1
const fog_fade_time: float = 0.5

var hidden_color: Color = Color(0.0, 0.0, 0.0, 0.0)
var fog_color: Color = Color("0d0d0d")
var select_color: Color = Color("ffffc9dc")
var hover_color: Color = Color("ffffc978")

var border
var fog

func _ready() -> void:
	if border:
		border.color = hidden_color
	if fog:
		fog.color = fog_color


func _reveal_fog() -> void:
	if !fog:
		return
	var t = get_tree().create_tween()
	t.tween_property(fog,"color",hidden_color,fog_fade_time)


func _show_fog() -> void:
	if !fog:
		return
	var t = get_tree().create_tween()
	t.tween_property(fog,"color",fog_color,highlight_fade_time)


func _show_hover_highlight() -> void:
	if !border:
		return
	var t = get_tree().create_tween()
	t.tween_property(border,"color",hover_color,highlight_fade_time)
	hovering.emit(self)


func _hide_hover_highlight() -> void:
	if !border:
		return
	var t = get_tree().create_tween()
	t.tween_property(border,"color",hidden_color,highlight_fade_time)
	stopped_hovering.emit(self)


func _show_select_highlight() -> void:
	if !border:
		return
	var t = get_tree().create_tween()
	t.tween_property(border,"color",select_color,highlight_fade_time)


#func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#	if Input.is_action_just_pressed("select"):
#		_show_select_highlight()
#		selected.emit(self)
