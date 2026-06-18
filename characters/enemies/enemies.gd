extends Node2D

@onready var spawn_location_1 = $"../../EnemySpawner/Marker2D"
@onready var spawn_location_2 = $"../../EnemySpawner/Marker2D2"
@onready var spawn_location_3 = $"../../EnemySpawner/Marker2D3"
@onready var spawn_location_4 = $"../../EnemySpawner/Marker2D4"
@onready var spawn_location_5 = $"../../EnemySpawner/Marker2D5"
@onready var spawn_location_6 = $"../../EnemySpawner/Marker2D6"

var spawn_locations: Array


var enemies_to_spawn: Dictionary = {
	"yellow_archer": preload("res://characters/enemies/yellow_archer/yellow_archer.tscn")
	
	
}


func _ready() -> void:
	#Add spawn locations to array for random pick
	spawn_locations.append(spawn_location_1)
	spawn_locations.append(spawn_location_2)
	spawn_locations.append(spawn_location_3)
	spawn_locations.append(spawn_location_4)
	spawn_locations.append(spawn_location_5)
	spawn_locations.append(spawn_location_6)
	
	GameManager.start_of_wave.connect(_on_wave_start)


func spawn_enemies(spawn: int) -> void:
	var random_marker = spawn_locations[randi() % spawn_locations.size()]
	
	for x in spawn:
		var random_enemy = enemies_to_spawn.values()[randi() % enemies_to_spawn.size()]
		var enemy_instance: Node = random_enemy.instantiate()
		
		var offset = Vector2(randf_range(-64, 64), randf_range(-64, 64))
		enemy_instance.position = random_marker.position + offset
		
		add_child(enemy_instance)
		enemy_instance.add_to_group("enemies")
	
	#print("enemy spawned")
	#print(get_tree().get_nodes_in_group("enemies"))


func _on_wave_start(_amount) -> void:
	spawn_enemies(_amount)
