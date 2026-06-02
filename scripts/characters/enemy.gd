extends CharacterBody2D

@export var enemy_blueprint: EnemyData

@onready var sprite_2d = $Sprite2D
var current_health: float


func _ready() -> void:
	setup_enemy()


func _physics_process(delta):
	# Move using the speed dictated by the resource
	#velocity = Vector2.LEFT * enemy_blueprint.move_speed
	move_and_slide()


func setup_enemy():
	# 1. Apply visual data
	sprite_2d.texture = enemy_blueprint.sprite_texture
	sprite_2d.scale = enemy_blueprint.scale
	sprite_2d.frame = 0
	
	# 2. Apply gameplay data
	current_health = enemy_blueprint.max_health
	
	print("Spawned a ", enemy_blueprint.name, " with ", current_health, " HP!")
