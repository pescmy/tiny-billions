extends Node

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


var current_building_type: String = ""
var current_building_size: Vector2i = Vector2i(1, 1)


var occupied_cells: Dictionary = {}

var in_build_mode: bool = false
var current_build_scene: PackedScene = null


func is_cell_occupied(grid_position: Vector2i) -> bool:
	return occupied_cells.has(grid_position)


func can_place_building(grid_position) -> bool:
	for x in current_building_size.x:
		for y in current_building_size.y:
			var cell = grid_position + Vector2i(x, y)
			if occupied_cells.has(cell):
				return false
	return true


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
				in_build_mode = true

			KEY_2:
				current_build_scene = buildings["house"]
				current_building_type = "house"
				current_building_size = building_size["house"]
				in_build_mode = true

			KEY_3:
				current_build_scene = buildings["wall"]
				current_building_type = "wall"
				current_building_size = building_size["wall"]
				in_build_mode = true

			KEY_ESCAPE:
				current_build_scene = null
				in_build_mode = false
