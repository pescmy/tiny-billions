class_name HealthComponent
extends Node

@export var max_health: float = 100
@onready var current_health: float = max_health

signal health_depleted


func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health <= 0:
		health_depleted.emit()
