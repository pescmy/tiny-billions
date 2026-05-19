extends Node2D



func _ready() -> void:
	$WorldNavigation.bake_navigation_polygon()
