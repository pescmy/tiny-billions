extends Node2D

const tile_size: int = 64


func world_to_grid(world_position: Vector2) -> Vector2i:
	return Vector2i(
		floori(world_position.x / tile_size),
		floori(world_position.y / tile_size)
	)
	


func grid_to_world(grid_position: Vector2) -> Vector2:
	return Vector2(
		grid_position.x * tile_size,
		grid_position.y * tile_size
	)
