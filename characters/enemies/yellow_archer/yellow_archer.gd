extends CharacterBody2D

@export_category("Stats")
@export var max_health: float = 20.0
@export var move_speed: float = 100.0
@export var attack_dmg: float = 5.0
@export var attack_speed: float = 1.0
@export var attack_range: float = 200.0

var _velocity = Vector2()
const MASS = 10.0
const ARRIVE_DISTANCE = 10.0

var target_position: Vector2

@export_category("Audio")
@export var death_sound: AudioStream

var current_health: float


func _ready() -> void:
	BuildManager.building_placed.connect(_on_building_placed)
	current_health = max_health



func _physics_process(_delta):
	if not _move_to(target_position):
		pass # attack later



func _find_target() -> void:
	var distance: float = 10000000.0
	var smallest_distance: float = 10000000.0
	
	for building_location in BuildManager.occupied_cells: # or player location
		distance = global_position.distance_squared_to(GridHelper.grid_to_world(building_location))
		
		if distance < smallest_distance:
			smallest_distance = distance
			target_position = GridHelper.grid_to_world(building_location)
		
	print(smallest_distance)
	print(target_position)


func _move_to(local_position):
	var desired_velocity = (local_position - position).normalized() * move_speed
	var steering = desired_velocity - _velocity
	
	if not position.distance_to(local_position) < attack_range:
		_velocity += steering / MASS
		position += _velocity * get_process_delta_time()
		_animate(_velocity.x, _velocity.y)
		return position.distance_to(local_position) < attack_range
	else:
		return true


func _animate(x, _y) -> void:
	if x < 0:
		$Sprite2D.flip_h = true
	if x > 0:
		$Sprite2D.flip_h = false

func _on_building_placed() -> void:
	_find_target()


func _on_attack_timer_timeout() -> void:
	pass # Replace with function body.
