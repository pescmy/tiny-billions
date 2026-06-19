extends StaticBody2D

@export var grid_size: Vector2i = Vector2i(1, 1)
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

const TILE_SIZE: float = 64 

var floating_text: PackedScene = preload("res://ui/floating_text/floating_text.tscn")

var gold_produced: int = 100

@onready var health_component = $HealthComponent
@onready var building_shake_component = $BuildingShake
@onready var build_sound = $AudioStreamPlayer2D

func _ready() -> void:
	sprite.position.x = grid_size.x * TILE_SIZE / 2
	sprite.position.y = grid_size.y * TILE_SIZE / 2
	
	collision.position.x = grid_size.x * TILE_SIZE / 2
	collision.position.y = grid_size.y * TILE_SIZE / 2
	
	var nav_obstacle = $NavigationObstacle2D
	var w = grid_size.x * TILE_SIZE
	var h = grid_size.y * TILE_SIZE
	nav_obstacle.vertices = PackedVector2Array([
		Vector2(0, 0),
		Vector2(w, 0),
		Vector2(w, h),
		Vector2(0, h)
	])
	
	building_shake_component.shake()
	build_sound.play()
	health_component.health_depleted.connect(_on_building_destroyed)



func _on_timer_timeout() -> void:
	GameManager.add_gold(gold_produced)
	spawn_gold_popup()


func spawn_gold_popup() -> void:
	var popup = floating_text.instantiate()
	popup.text = "+ " + str(gold_produced) + " Gold"
	popup.global_position = global_position + Vector2(20, 0)
	get_parent().add_child(popup)


func _on_building_destroyed() -> void:
	var grid_pos = GridHelper.world_to_grid(global_position)
	BuildManager.unmark_cell_occupied(grid_pos, grid_size)
	queue_free()
	print("House destroyed!")
