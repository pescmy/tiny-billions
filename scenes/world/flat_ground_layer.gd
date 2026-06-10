extends TileMapLayer

const CELL_SIZE = Vector2i(64, 64)

# The object for pathfinding on 2D grids.
var _astar = AStarGrid2D.new()

var _start_point = Vector2i()
var _end_point = Vector2i()
var _path = PackedVector2Array()

func _ready():
	
	var used = get_used_cells()
	var min_x = used[0].x
	var max_x = used[0].x
	var min_y = used[0].y
	var max_y = used[0].y
	for cell in used:
		min_x = min(min_x, cell.x)
		max_x = max(max_x, cell.x)
		min_y = min(min_y, cell.y)
		max_y = max(max_y, cell.y)
		
	print("Map bounds: ", min_x, ", ", min_y, " to ", max_x, ", ", max_y)
	# Region should match the size of the playable area plus one (in tiles).
	# In this demo, the playable area is 17×9 tiles, so the rect size is 18×10.
	_astar.region = Rect2i(min_x - 1, min_y - 1, (max_x - min_x) + 2, (max_y - min_y) + 2)
	_astar.cell_size = CELL_SIZE
	_astar.offset = CELL_SIZE * 0.5
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	#_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()

	refresh_solid_cells()


func round_local_position(local_position):
	return map_to_local(local_to_map(local_position))


func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false


func find_path(local_start_point, local_end_point):
	clear_path()
	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	_path = _astar.get_point_path(_start_point, _end_point)
	queue_redraw()
	return _path.duplicate()


func clear_path():
	if not _path.is_empty():
		_path.clear()
		queue_redraw()


func refresh_solid_cells() -> void:
	_astar.update()
	for i in range(_astar.region.position.x, _astar.region.end.x):
		for j in range(_astar.region.position.y, _astar.region.end.y):
			var pos = Vector2i(i, j)
			_astar.set_point_solid(pos, false)
			
			# No tile here = not walkable ground
			if get_cell_source_id(pos) == -1:
				_astar.set_point_solid(pos)
				continue
				
			# Building occupying this cell
			if BuildManager.occupied_cells.has(pos):
				_astar.set_point_solid(pos)
