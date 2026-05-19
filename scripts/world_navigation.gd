@tool
extends NavigationRegion2D

func _ready():
	var poly = navigation_polygon
	poly.source_geometry_mode = NavigationPolygon.SOURCE_GEOMETRY_ROOT_NODE_CHILDREN
	poly.parsed_geometry_type = NavigationPolygon.PARSED_GEOMETRY_STATIC_COLLIDERS
	poly.clear_outlines()
	poly.vertices = PackedVector2Array()
	navigation_polygon = poly
	
	# Wait for everything to be ready
	await get_tree().process_frame
	await get_tree().process_frame
	
	print("Children visible: ", get_child_count())
	print("Baking now...")
	bake_navigation_polygon()
	await bake_finished
	
	print("Post-bake vertex count: ", navigation_polygon.vertices.size())
	print("Outline count: ", navigation_polygon.get_outline_count())
