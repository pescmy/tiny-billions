extends TileMapLayer


var GridSize := 5
var Dic: Dictionary = {}


func _ready() -> void:
	for x in GridSize:
		for y in GridSize:
			var grid_pos = Vector2i(x, y)
			Dic[grid_pos] = {
				"Type": "Grass"
			}
			set_cell(grid_pos, 1, Vector2i(0, 0), 0)
	print(Dic)




func _process(delta: float) -> void:
	var tile = local_to_map(get_local_mouse_position())
	#print(tile)
	if Dic.has(tile):
		print(tile)
