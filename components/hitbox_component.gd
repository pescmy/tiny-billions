class_name HitboxComponent
extends Area2D

# In the Inspector, you drag and drop the HealthComponent node into this slot
@export var health_component: HealthComponent
var offset: Vector2


func _ready():
	var parent_collision = get_parent().get_node_or_null("CollisionShape2D")
	var my_collision = get_node_or_null("CollisionShape2D")
	
	offset = get_parent().grid_size * 64 / 2
	
	if parent_collision and my_collision:
		my_collision.shape = parent_collision.shape
		my_collision.position = offset



func handle_hit(damage_amount: float):
	if health_component:
		health_component.take_damage(damage_amount)
