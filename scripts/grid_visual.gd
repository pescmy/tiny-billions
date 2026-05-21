extends Node2D




func _process(_delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var mouse_position = get_global_mouse_position()
	var grid_position = GridHelper.world_to_grid(mouse_position)
	var building_size: Vector2i = BuildManager.current_building_size
	
	if BuildManager.in_build_mode:
		for x in building_size.x:
			for y in building_size.y:
				var cell = grid_position + Vector2i(x, y)  # which tile are we on
				var cell_world = GridHelper.grid_to_world(cell)  # where is that tile in the world
				if BuildManager.is_cell_occupied(cell):  # check THIS cell not the anchor
					draw_rect(Rect2i(cell_world, Vector2i(64, 64)), Color(1, 0, 0, 0.4))
				else:
					draw_rect(Rect2i(cell_world, Vector2i(64, 64)), Color(0, 1, 0, 0.4))
	
