class_name HexUtils

static func hex_distance(a: Vector2i, b: Vector2i) -> int:
	var ac: Vector3i = _odd_r_to_cube(a)
	var bc: Vector3i = _odd_r_to_cube(b)
	return _cube_distance(ac, bc)


static func _cube_distance(a: Vector3i, b: Vector3i) -> int:
	var dx: int = abs(a.x - b.x)
	var dy: int = abs(a.y - b.y)
	var dz: int = abs(a.z - b.z)
	return (dx + dy + dz) / 2


static func _odd_r_to_cube(h: Vector2i) -> Vector3i:
	# q = x (column), r = y (row)
	var q: int = h.x
	var r: int = h.y
	var x: int = q - ((r - (r & 1)) / 2)
	var z: int = r
	var y: int = -x - z
	return Vector3i(x, y, z)


static func neighbors_odd_r(cell: Vector2i) -> Array[Vector2i]:
	# Returns 6 neighbor offsets for the given cell parity (odd-r)
	if (cell.y & 1) == 1:
		return [
			Vector2i(1, 0),
			Vector2i(0, -1),
			Vector2i(1, -1),
			Vector2i(-1, 0),
			Vector2i(1, 1),
			Vector2i(0, 1),
		]

	return [
		Vector2i(1, 0),
		Vector2i(-1, -1),
		Vector2i(0, -1),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(-1, 1),
	]


static func cell_from_world(tilemap: TileMapLayer, world_pos: Vector2) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(world_pos))

static func cell_center_global(tilemap: TileMapLayer, cell: Vector2i) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(cell))


static func nav_path_points_to_cells(tilemap: TileMapLayer, points: PackedVector2Array) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var last: Vector2i = Vector2i(2147483647, 2147483647)

	for p: Vector2 in points:
		var cell: Vector2i = tilemap.local_to_map(tilemap.to_local(p))
		if cell != last:
			out.append(cell)
			last = cell

	return out

# ----------------------------
# Gap fill: ensure adjacency
# ----------------------------

static func fill_hex_gaps_odd_r(path: Array[Vector2i]) -> Array[Vector2i]:
	# Ensures every consecutive pair differs by exactly 1 hex (or 0).
	# Prevents "clamp to 1 but move 2" caused by sparse nav path sampling.
	if path.size() <= 1:
		return path

	var out: Array[Vector2i] = []
	out.append(path[0])

	for i: int in range(1, path.size()):
		var a: Vector2i = out[out.size() - 1]
		var b: Vector2i = path[i]

		var dist: int = hex_distance(a, b)

		while dist > 1:
			var next_step: Vector2i = _step_toward_odd_r(a, b)
			if next_step == a:
				break

			out.append(next_step)
			a = next_step
			dist = hex_distance(a, b)

		out.append(b)

	return out

static func _step_toward_odd_r(a: Vector2i, b: Vector2i) -> Vector2i:
	var best: Vector2i = a
	var best_d: int = 2147483647

	var neigh: Array[Vector2i] = neighbors_odd_r(a)

	for d: Vector2i in neigh:
		var c: Vector2i = a + d
		var cd: int = hex_distance(c, b)
		if cd < best_d:
			best_d = cd
			best = c

	return best

# ----------------------------
# Turn-move helper (N cells along path)
# ----------------------------

static func choose_destination_cell_along_path(
	start_cell: Vector2i,
	path_cells: Array[Vector2i],
	cells_per_turn: int
) -> Vector2i:
	# Expects path_cells to include start_cell optionally.
	# Returns start_cell if no move is possible.
	if cells_per_turn <= 0:
		return start_cell

	var p: Array[Vector2i] = path_cells.duplicate()

	if p.is_empty():
		return start_cell

	# Drop start cell if present
	if p[0] == start_cell:
		p.remove_at(0)

	if p.is_empty():
		return start_cell

	var steps: int = cells_per_turn
	if steps > p.size():
		steps = p.size()

	return p[steps - 1]
