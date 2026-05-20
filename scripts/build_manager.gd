extends Node2D

var buildings: Dictionary = {
	"town_centre": preload("res://scenes/buildings/base/towncenter.tscn"),
	"wall": preload("res://scenes/buildings/base/wall.tscn"),
	"house": preload("res://scenes/buildings/base/house.tscn")
}

var occupied_cells: Dictionary = {}

var in_build_mode: bool = false
var current_build_scene: PackedScene = null


func _ready() -> void:
	print(buildings)



func _process(_delta: float) -> void:
	pass






func is_cell_occupied() -> bool:
	return 1




func mark_cell_occupied() -> void:
	pass







func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				current_build_scene = buildings["town_centre"]
				in_build_mode = true

			KEY_2:
				current_build_scene = buildings["house"]
				in_build_mode = true

			KEY_3:
				current_build_scene = buildings["wall"]
				in_build_mode = true

			KEY_ESCAPE:
				current_build_scene = null
				in_build_mode = false
