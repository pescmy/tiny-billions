extends StaticBody2D

@export var grid_size: Vector2i = Vector2i(1, 1)
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D


const FRAME_MAP = {
	0b0000: 12,  # isolated
	0b0010: 13,  # right only
	0b1000: 15,  # left only
	0b1010: 14,  # horizontal straight (right + left)
	0b0100: 0,   # down only
	0b0110: 1,   # right + down
	0b1100: 3,  # left + down
	0b1110: 2,  # right + left + down (T top)
	0b0001: 8,   # up only
	0b0011: 9,   # right + up
	0b1001: 11,   # left + up
	0b1011: 10,   # right + left + up (T bottom)
	0b0101: 4,   # vertical straight (up + down)
	0b0111: 5,   # right + up + down (T left)
	0b1101: 7,   # left + up + down (T right)
	0b1111: 6,   # cross
}


func _ready() -> void:
	sprite.position.x = grid_size.x * 64.0 / 2
	sprite.position.y = grid_size.y * 64.0 / 2
	
	collision.position.x = grid_size.x * 64.0 / 2
	collision.position.y = grid_size.y * 64.0 / 2
	
	var nav_obstacle = $NavigationObstacle2D
	var w = grid_size.x * 64.0
	var h = grid_size.y * 64.0
	nav_obstacle.vertices = PackedVector2Array([
		Vector2(0, 0),
		Vector2(w, 0),
		Vector2(w, h),
		Vector2(0, h)
	])
	
	collision.shape.size = Vector2(64, 64)
	collision.position = Vector2(32, 32)
		
	BuildManager.cells_changed.connect(_update_sprite)
	_update_sprite()

func _update_sprite() -> void:
	var grid_pos = GridHelper.world_to_grid(global_position)
	var up    = BuildManager.occupied_cells.get(grid_pos + Vector2i(0, -1)) == "wall"
	var right = BuildManager.occupied_cells.get(grid_pos + Vector2i(1, 0)) == "wall"
	var down  = BuildManager.occupied_cells.get(grid_pos + Vector2i(0, 1)) == "wall"
	var left  = BuildManager.occupied_cells.get(grid_pos + Vector2i(-1, 0)) == "wall"
	
	var mask = (up as int) | ((right as int) << 1) | ((down as int) << 2) | ((left as int) << 3)
	$Sprite2D.frame = FRAME_MAP.get(mask, 12)
