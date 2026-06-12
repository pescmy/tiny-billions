extends Node2D

const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color.WHITE * Color(1, 1, 1, 0.5)

var _path = PackedVector2Array()

func set_path(path: PackedVector2Array) -> void:
	_path = path
	queue_redraw()

func clear() -> void:
	_path.clear()
	queue_redraw()

func _draw() -> void:
	if _path.is_empty():
		return
	var last_point = _path[0]
	for index in range(1, len(_path)):
		var current_point = _path[index]
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		draw_circle(current_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = current_point
