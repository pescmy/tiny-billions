extends CharacterBody2D

@export_category("Stats")
@export var move_speed: float = 250.0
@export var attack_dmg: float = 50.0
@export var attack_speed: float = 5.0
@export var attack_range: float = 64.0
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
var target: Node
var target_position: Vector2


signal king_position_changed(global_position: Vector2)


func _ready() -> void:
	if build_radius.shape is CircleShape2D:
		build_radius.shape.radius = radius_size
	_change_state(State.IDLE)



func _process(_delta):
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
	
	enemies = get_tree().get_nodes_in_group("enemies")
	print(enemies)
	
	_find_target()



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
	smallest_distance = 10000000.0 
	print("enemy found")
	for enemy in enemies:
		distance = global_position.distance_squared_to(enemy.global_position)

			
		if distance < smallest_distance:
			smallest_distance = distance
			target = enemy
			# Sync target_position directly to the building's physical center
			target_position = enemy.global_position
			print("target distance got")
			
	
	if is_instance_valid(target):
		attack_timer.start()
		print(attack_timer.time_left)



#func _attack_target() -> void:
	#if not is_instance_valid(target_building):
		#attack_timer.stop()
		#_find_target()
	#
	#if is_instance_valid(target_building):
		#var distance_to_target = global_position.distance_to(target_building.global_position)
		#print(attack_range)
		#print(distance_to_target)
		#
		#if distance_to_target <= attack_range:
			#
			## Stop moving completely during the attack strike
			#_velocity = Vector2.ZERO 
			#is_attacking = true
			## Play the attack animation
			#$AnimationPlayer.play("attack")
			#
			## Face the target while attacking
			#if target_building.global_position.x < global_position.x:
				#$Sprite2D.flip_h = true
			#else:
				#$Sprite2D.flip_h = false
			#
			#
			#var health_component = target_building.get_node("HealthComponent")
			#health_component.take_damage(attack_dmg)
			#print("Attacked building for ", attack_dmg, " damage.")
