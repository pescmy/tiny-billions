class_name EnemyData
extends Resource

@export_category("Stats")
@export var max_health: float = 0.0
@export var move_speed: float = 0.0
@export var attack_dmg: float = 0.0
@export var attack_speed: float = 0.0
@export var attack_range: float = 0.0

@export_category("Visuals")
@export var name: String = "Template"
@export var sprite_texture: Texture2D
@export var scale: Vector2 = Vector2(1, 1)

@export_category("Audio")
@export var death_sound: AudioStream
