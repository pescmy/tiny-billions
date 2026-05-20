extends Node2D

var mouse_position: Vector2
var grid_position: Vector2i




func _ready() -> void:
	$WorldNavigation.bake_navigation_polygon()


func _process(_delta: float) -> void:
	check_mouse_position()



func check_mouse_position() -> void:
	if BuildManager.in_build_mode:
		mouse_position = get_global_mouse_position()
		
		grid_position = GridHelper.world_to_grid(mouse_position)
		print(grid_position)
