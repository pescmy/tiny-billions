extends CharacterBody2D


@export var speed: int = 250
@onready var navigation_agent := $NavigationAgent2D
@onready var build_radius = $BuildRadius/CollisionShape2D
var radius_size: float = 500.0
var clicked_position: Vector2

signal king_position_changed(global_position: Vector2)

func _ready() -> void:
	if build_radius.shape is CircleShape2D:
		build_radius.shape.radius = radius_size


func _physics_process(_delta: float) -> void:
	# Wait one physics frame to make sure the NavigationServer is synchronized
	await get_tree().physics_frame
	_move_king()


func _move_king() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
		
	var next_position: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_position)
	velocity = direction * speed
	
	_animate(direction.x, direction.y)
	move_and_slide()
	king_position_changed.emit(global_position)


func _animate(x, _y) -> void:
	if x < 0:
		$Sprite2D.flip_h = true
	if x > 0:
		$Sprite2D.flip_h = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Check if it's a right-click AND ensure it's the press event, not the release
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			clicked_position = get_global_mouse_position()
			navigation_agent.target_position = clicked_position
			print("Right click target set to: ", clicked_position)
