extends StaticBody2D

@export var grid_size: Vector2i = Vector2i(1, 1)
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D


func _ready() -> void:
	sprite.position.x = grid_size.x * 64.0 / 2
	sprite.position.y = grid_size.y * 64.0 / 2
	
	collision.position.x = grid_size.x * 64.0 / 2
	collision.position.y = grid_size.y * 64.0 / 2
