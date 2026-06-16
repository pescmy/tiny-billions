extends Node2D

@onready var spawn_location_1 = $"../../EnemySpawner/Marker2D"
@onready var spawn_location_2 = $"../../EnemySpawner/Marker2D2"
@onready var spawn_location_3 = $"../../EnemySpawner/Marker2D3"
@onready var spawn_location_4 = $"../../EnemySpawner/Marker2D4"
@onready var spawn_location_5 = $"../../EnemySpawner/Marker2D5"
@onready var spawn_location_6 = $"../../EnemySpawner/Marker2D6"

var spawn_locations: Array

@onready var spawn_timer: Timer
var spawn_time: float = 2.0

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
	
	#Add timer to spawn enemies, should be set to however long before wave starts. Should also loop to add multiple enemies based on wave
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.wait_time = spawn_time
	
	spawn_timer.timeout.connect(_on_timer_timeout)
	spawn_timer.start()



func _process(_delta: float) -> void:
	pass#print(spawn_timer.time_left)

func _on_timer_timeout() -> void:
	var random_enemy = enemies_to_spawn.values()[randi() % enemies_to_spawn.size()]
	var enemy_instance: Node = random_enemy.instantiate()
	
	var random_marker = spawn_locations[randi() % spawn_locations.size()]
	
	enemy_instance.position = random_marker.position
	add_child(enemy_instance)
	enemy_instance.add_to_group("enemies")
	
	#print("enemy spawned")
	#print(get_tree().get_nodes_in_group("enemies"))
	
