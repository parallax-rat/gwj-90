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
	var q: int = h.x
	var r: int = h.y
	var x: int = q - ((r - (r & 1)) / 2)
	var z: int = r
	var y: int = -x - z
	return Vector3i(x, y, z)
