class_name HitboxComponent
extends Area2D

# In the Inspector, you drag and drop the HealthComponent node into this slot
@export var health_component: HealthComponent






func handle_hit(damage_amount: float):
	if health_component:
		health_component.take_damage(damage_amount)
