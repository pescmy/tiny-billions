extends CharacterBody2D

@export var move_speed: int = 250
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
