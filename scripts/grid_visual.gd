extends Node2D

var king_position: Vector2
var radius: float = BuildManager.allowed_distance



func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var mouse_position = get_global_mouse_position()
	var grid_position = GridHelper.world_to_grid(mouse_position)
	var building_size: Vector2i = BuildManager.current_building_size
	
	var is_in_radius = BuildManager.in_king_radius(king_position, mouse_position)
	
	if BuildManager.in_build_mode:
		draw_arc(king_position, radius, 0, TAU, 100, Color(1,0,0,1))
		for x in building_size.x:
			for y in building_size.y:
				var cell = grid_position + Vector2i(x, y)
				var cell_world = GridHelper.grid_to_world(cell)
				
				if BuildManager.is_cell_occupied(cell) or not is_in_radius:
					draw_rect(Rect2i(cell_world, Vector2i(64, 64)), Color(1, 0, 0, 0.4))
				else:
					draw_rect(Rect2i(cell_world, Vector2i(64, 64)), Color(0, 1, 0, 0.4))
	
