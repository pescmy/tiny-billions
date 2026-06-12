class_name WorldScene
extends Node2D

var mouse_position: Vector2
var grid_position: Vector2i
@onready var buildings: Node2D = $Buildings
@onready var king = $Characters/King
var king_position: Vector2
var ghost: Node2D = null


func _ready() -> void:
	king_position = king.global_position
	
	
	BuildManager.building_selected.connect(_on_building_selected)
	BuildManager.exit_build_mode.connect(_on_exit_build_mode)
	king.king_position_changed.connect(_on_king_position_changed)



func _process(_delta: float) -> void:
	check_mouse_position()
	$GridVisual.king_position = king.global_position
	$GridVisual.flat_ground_layer = $Layers/FlatGroundLayer
	
	if ghost:
		ghost.global_position = GridHelper.grid_to_world(grid_position)


func check_mouse_position() -> void:
	if BuildManager.in_build_mode:
		mouse_position = get_global_mouse_position()
		grid_position = GridHelper.world_to_grid(mouse_position)


func place_building() -> void:
	var new_building = BuildManager.current_build_scene.instantiate()
	var world_position = GridHelper.grid_to_world(grid_position)
	var building_type: String = BuildManager.current_building_type
	
	var can_place = BuildManager.can_place_building(grid_position)
	var in_radius = BuildManager.in_king_radius(king_position, mouse_position)
	var valid_ground = is_valid_ground()

	if can_place and in_radius and valid_ground:
		if GameManager.spend_gold(BuildManager.current_building_cost):
			# place the building
			new_building.global_position = world_position
			buildings.add_child(new_building)
			
			BuildManager.mark_cell_occupied(grid_position, building_type)
			
			delete_ghost_building()
			create_ghost_building(BuildManager.current_build_scene)
			
			$Layers/FlatGroundLayer.refresh_solid_cells()
			

			
		else:
			pass
			#TODO
			#add UI rather than print


func create_ghost_building(building) -> void:
	delete_ghost_building()
	ghost = building.instantiate()
	
	ghost.modulate = Color(1, 1, 1, 0.5)
	add_child(ghost)


func is_valid_ground() -> bool:
	var building_size = BuildManager.current_building_size
	for x in building_size.x:
		for y in building_size.y:
			var cell = grid_position + Vector2i(x, y)
			if $Layers/FlatGroundLayer.get_cell_source_id(cell) == -1:
				return false
	return true


func delete_ghost_building() -> void:
	if ghost:
		ghost.queue_free()
		ghost = null


func _on_building_selected(scene: PackedScene) -> void:
	create_ghost_building(scene)


func _on_exit_build_mode() -> void:
	delete_ghost_building()


func _on_king_position_changed(king_global_position) -> void:
	king_position = king_global_position
	#print(king_position)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and BuildManager.in_build_mode:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				place_building()
				
