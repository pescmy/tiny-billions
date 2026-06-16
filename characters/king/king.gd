extends CharacterBody2D

@export_category("Stats")
@export var move_speed: float = 250.0
@export var attack_dmg: float = 15.0
@export var attack_speed: float = 1.0
@export var attack_range: float = 64.0 * 6
@onready var attack_timer: Timer = $AttackTimer

@export_category("Audio")
@export var death_sound: AudioStream

@onready var build_radius = $BuildRadius/CollisionShape2D
@onready var _tile_map = $"../../Layers/FlatGroundLayer"
@onready var _path_visual = $"../../PathVisual"

var radius_size: float = 500.0
var _click_position = Vector2()
var _path = PackedVector2Array()
var _next_point = Vector2()

const MASS = 10.0
const ARRIVE_DISTANCE = 10.0

var _velocity = Vector2()

enum State { IDLE, FOLLOW }
var _state = State.IDLE

var enemies
var smallest_distance: float = 10000000.0
var distance: float
var target: Node2D = null # Cast to Node2D for easy position access
var target_position: Vector2
var is_attacking: bool = false


signal king_position_changed(global_position: Vector2)


func _ready() -> void:
	if build_radius.shape is CircleShape2D:
		build_radius.shape.radius = radius_size
			
		# Automatically configure your timer based on attack_speed stat
		# If attack_speed is 5, wait_time becomes 0.2 seconds (5 attacks per second)
		attack_timer.wait_time = 1.0 / attack_speed
		attack_timer.one_shot = true
		
		_change_state(State.IDLE)



func _process(_delta):
	_find_target()
	_attack_target()
	
	if _state != State.FOLLOW:
		return
	
	if not BuildManager.in_build_mode:
		var arrived_to_next_point = _move_to(_next_point)
		king_position_changed.emit(global_position)
		if arrived_to_next_point:
			_path.remove_at(0)
			if _path.is_empty():
				_change_state(State.IDLE)
				return
			_next_point = _path[0]
	


func _unhandled_input(event):
	_click_position = get_global_mouse_position()
	if _tile_map.is_point_walkable(_click_position) and not BuildManager.in_build_mode:
		if event.is_action_pressed(&"teleport_to", false, true):
			_change_state(State.IDLE)
			global_position = _tile_map.round_local_position(_click_position)
		elif event.is_action_pressed(&"move_to"):
			_change_state(State.FOLLOW)


func _move_to(local_position):
	var desired_velocity = (local_position - position).normalized() * move_speed
	var steering = desired_velocity - _velocity
	_velocity += steering / MASS
	position += _velocity * get_process_delta_time()
	_animate(_velocity.x, _velocity.y)
	return position.distance_to(local_position) < ARRIVE_DISTANCE


func _animate(x, _y) -> void:
	if x < 0:
		$Sprite2D.flip_h = true
	if x > 0:
		$Sprite2D.flip_h = false


func _change_state(new_state):
	if new_state == State.IDLE:
		_tile_map.clear_path()
		_path_visual.clear()
		_velocity = Vector2.ZERO
	elif new_state == State.FOLLOW:
		_path = _tile_map.find_path(position, _click_position)
		if _path.size() < 2:
			_change_state(State.IDLE)
			return
		_path_visual.set_path(_path)
		_next_point = _path[1]
	_state = new_state






func _find_target() -> void:    
	enemies = get_tree().get_nodes_in_group("enemies")
	smallest_distance = INF
	target = null # Reset target to look for the closest valid alive one

	for enemy in enemies:
			if is_instance_valid(enemy):
				# Regular distance check to match attack_range comfortably
				distance = global_position.distance_to(enemy.global_position)
				
				if distance < smallest_distance:
					smallest_distance = distance
					target = enemy
					target_position = enemy.global_position


func _attack_target() -> void:
	# If no valid target exists or it moves out of range, clear flags and stop
	if not is_instance_valid(target) or smallest_distance > attack_range:
		is_attacking = false
		return
	
	# TARGET IS VALID AND IN RANGE
	# Crucial Check: Only attack if our weapon cooldown timer is completely finished
	if attack_timer.is_stopped():
		is_attacking = true
		
		# Start the cooldown countdown right now
		attack_timer.start()
		
		# Turn to face enemy during strike
		if target.global_position.x < global_position.x:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
			
		# Optional: Play an animation if it exists
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("attack")
		
		# Safe Node Fetching: Prevents crashes if an enemy missing a component is tagged
		var health_component = target.get_node_or_null("HealthComponent")
		if health_component and health_component.has_method("take_damage"):
			health_component.take_damage(attack_dmg)
			#print("Successfully hit enemy for ", attack_dmg, " damage.")
		else:
			# Fallback if your enemy script handles damage directly without a component node
			if target.has_method("take_damage"):
				target.take_damage(attack_dmg)
