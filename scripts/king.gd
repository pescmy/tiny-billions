extends CharacterBody2D


@export var speed: int = 250
@onready var navigation_agent: = $NavigationAgent2D
var clicked_position: Vector2

func _physics_process(_delta: float) -> void:
	# Wait one physics frame to make sure the NavigationServer is synchronized
	await get_tree().physics_frame
	_move_king()
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Check if it's a right-click AND ensure it's the press event, not the release
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			clicked_position = get_global_mouse_position()
			navigation_agent.target_position = clicked_position
			print("Right click target set to: ", clicked_position)


func _move_king() -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
		
	var next_position: Vector2 = navigation_agent.get_next_path_position()
	var direction: Vector2 = global_position.direction_to(next_position)
	print(direction)
	velocity = direction * speed
	
	_animate(direction.x, direction.y)
	
	move_and_slide()


func _animate(x, y) -> void:
	if x < 0:
		$Sprite2D.flip_h = true
	if x > 0:
		$Sprite2D.flip_h = false
