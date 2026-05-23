extends Camera2D


@export var base_speed: float = 1000.0
@export var acceleration: float = 10.0

var velocity: Vector2 = Vector2.ZERO

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0
var target_zoom: float = 1.0

const EDGE_MARGIN: int = 20

@onready var king: CharacterBody2D = $"../Characters/King"

func _process(delta: float) -> void:
	_move_camera(delta)
	_zoom(delta)
	_focus_king()
	#_edge_scrolling(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clamp(target_zoom + zoom_speed, min_zoom, max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clamp(target_zoom - zoom_speed, min_zoom, max_zoom)


func _move_camera(delta) -> void:
	var input_dir := Vector2.ZERO
	
	input_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_dir = input_dir.normalized()

	var target_velocity = input_dir * base_speed
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	position += velocity * delta


func _zoom(delta) -> void:
	zoom = zoom.lerp(Vector2(target_zoom, target_zoom), 10.0 * delta)


func _focus_king() -> void:
	var focus = Input.is_action_just_pressed("find_king")
	if focus:
		global_position = king.global_position	


func _edge_scrolling(delta) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var camera_size = get_viewport().size

	var input_dir := Vector2.ZERO
	
	if mouse_position.x < EDGE_MARGIN:
		input_dir.x = -1
	elif mouse_position.x > camera_size.x - EDGE_MARGIN:
		input_dir.x = 1
		
	if mouse_position.y < EDGE_MARGIN:
		input_dir.y = -1
	elif mouse_position.y > camera_size.y - EDGE_MARGIN:
		input_dir.y = 1
	
	var target_velocity = input_dir * base_speed
	velocity = velocity.lerp(target_velocity, acceleration * delta)
	position += velocity * delta
