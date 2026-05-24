extends Node
#singleton

var buildings: Dictionary = {
	"town_centre": preload("res://scenes/buildings/base/towncentre.tscn"),
	"house": preload("res://scenes/buildings/base/house.tscn"),
	"wall": preload("res://scenes/buildings/base/wall.tscn")
	
}

var building_size: Dictionary = {
	"town_centre": Vector2i(5, 4),
	"house": Vector2i(2, 3),
	"wall": Vector2i(1, 1)
}

var building_cost: Dictionary = {
	"town_centre": 9999,
	"house": 100,
	"wall": 5
}


var current_building_type: String = ""
var current_building_size: Vector2i = Vector2i(1, 1)
var current_building_cost: int

var occupied_cells: Dictionary = {}

var in_build_mode: bool = false
var build_in_king_radius: bool = false
var current_build_scene: PackedScene = null

var king_global_position: Vector2 = Vector2.ZERO
var allowed_distance: float = 500.0

signal building_selected(scene: PackedScene)
signal exit_build_mode


func is_cell_occupied(grid_position: Vector2i) -> bool:
	return occupied_cells.has(grid_position)


func can_place_building(grid_position: Vector2i) -> bool:
	# Does the player have enough gold? (Safe check, doesn't spend!)
	if not GameManager.has_enough_gold(current_building_cost):
		return false
		
	# Is the king close enough?
	if not build_in_king_radius:
		return false
		
	# Are any target grid cells blocked?
	for x in current_building_size.x:
		for y in current_building_size.y:
			var cell = grid_position + Vector2i(x, y)
			if occupied_cells.has(cell):
				return false # Blocked!
				
	return true


func in_king_radius(king_position: Vector2, mouse_position: Vector2) -> bool:
	king_global_position = king_position 
	
	if king_position.distance_to(mouse_position) <= allowed_distance:
		build_in_king_radius = true
		return true
	else:
		build_in_king_radius = false
		return false
	

func mark_cell_occupied(grid_position, building) -> void:
	for x in current_building_size.x:
		for y in current_building_size.y:
			var cell = grid_position + Vector2i(x, y)
			occupied_cells[cell] = building


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				current_build_scene = buildings["town_centre"]
				current_building_type = "town_centre"
				current_building_size = building_size["town_centre"]
				current_building_cost = building_cost["town_centre"]
				in_build_mode = true
				building_selected.emit(current_build_scene)

			KEY_2:
				current_build_scene = buildings["house"]
				current_building_type = "house"
				current_building_size = building_size["house"]
				current_building_cost = building_cost["house"]
				in_build_mode = true
				building_selected.emit(current_build_scene)

			KEY_3:
				current_build_scene = buildings["wall"]
				current_building_type = "wall"
				current_building_size = building_size["wall"]
				current_building_cost = building_cost["wall"]
				in_build_mode = true
				building_selected.emit(current_build_scene)

			KEY_ESCAPE:
				current_build_scene = null
				in_build_mode = false
				exit_build_mode.emit()
