extends CharacterBody2D

@export_category("Stats")
@export var max_health: float = 20.0
@export var move_speed: float = 100.0
@export var attack_dmg: float = 5.0
@export var attack_speed: float = 1.0
@export var attack_range: float = 128.0


@export_category("Audio")
@export var death_sound: AudioStream

var current_health: float


func _ready() -> void:
	current_health = max_health


func _physics_process(_delta):
	# Move using the speed dictated by the resource
	#velocity = Vector2.LEFT * enemy_blueprint.move_speed
	move_and_slide()
