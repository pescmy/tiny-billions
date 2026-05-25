extends StaticBody2D

@export var grid_size: Vector2i = Vector2i(1, 1)
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
var gold_produced: int = 100


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


func _on_timer_timeout() -> void:
	GameManager.add_gold(gold_produced)
