class_name WorldScene
extends Node2D

var mouse_position: Vector2
var grid_position: Vector2i
@onready var buildings: Node2D = $Buildings



func _ready() -> void:
	$WorldNavigation.bake_navigation_polygon()


func _process(_delta: float) -> void:
	check_mouse_position()



func check_mouse_position() -> void:
	if BuildManager.in_build_mode:
		mouse_position = get_global_mouse_position()
		grid_position = GridHelper.world_to_grid(mouse_position)



func place_building() -> void:
	var new_building = BuildManager.current_build_scene.instantiate()
	var world_position = GridHelper.grid_to_world(grid_position)
	var building_type: String = BuildManager.current_building_type
	
	if BuildManager.can_place_building(grid_position):
		new_building.global_position = world_position
		buildings.add_child(new_building)
		
		BuildManager.mark_cell_occupied(grid_position, building_type)
		
		print("world_position" + str(world_position))
	else:
		print("Can't build here, space is occupied!")
		#TODO
		#add UI rather than print



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and BuildManager.in_build_mode:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				place_building()
