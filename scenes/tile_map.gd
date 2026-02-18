class_name Map
extends TileMapLayer

signal clicked(coords)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("select"):
		print('unhandled input')
		var clicked_cell = local_to_map(get_local_mouse_position())
		var half_tile = Global.HEX_SIZE / 2
		var coords = map_to_local(clicked_cell) #- Vector2(half_tile,half_tile)
		coords = to_global(coords)
		clicked.emit(coords)
