extends CharacterBody2D

@export_category("Stats")
@export var move_speed: float = 100.0
@export var attack_dmg: float = 5.0
@export var attack_speed: float = 2.0
@export var attack_range: float = 64.0 * 1.5
@onready var attack_timer: Timer = $AttackTimer

@export_category("Audio")
@export var death_sound: AudioStream

@onready var health_component = $HealthComponent

var _velocity = Vector2()
const MASS = 10.0
const ARRIVE_DISTANCE = 10.0

var target_position: Vector2
var target_building: Node

var distance: float
var smallest_distance: float = INF

var is_attacking: bool = false


func _ready() -> void:
	BuildManager.building_placed.connect(_on_building_placed)
	health_component.health_depleted.connect(_on_killed)
	_find_target()
	
	
	attack_timer.wait_time = 1.0 / attack_speed


func _physics_process(_delta):
	if is_instance_valid(target_building):
		target_position = target_building.global_position
		
	if not _move_to(target_position):
		pass



func _find_target() -> void:    
	smallest_distance = INF
	
	for building_location in BuildManager.occupied_cells:
		var building_node = BuildManager.occupied_cells[building_location][1]
		
		if is_instance_valid(building_node):
			distance = global_position.distance_squared_to(building_node.global_position)
			
			if distance < smallest_distance:
				smallest_distance = distance
				target_building = building_node
				target_position = building_node.global_position
	
	if is_instance_valid(target_building):
		attack_timer.start()


func _move_to(local_position):
	var desired_velocity = (local_position - global_position).normalized() * move_speed
	var steering = desired_velocity - _velocity
	
	if not global_position.distance_to(local_position) < attack_range:
		_velocity += steering / MASS
		global_position += _velocity * get_process_delta_time()
		_animate(_velocity.x, _velocity.y)
		return global_position.distance_to(local_position) < attack_range
	else:
		_velocity = Vector2.ZERO
		_animate(0.0, 0.0)
		return true


#func _move_to(local_position):
	#var distance = global_position.distance_to(local_position)
	#if distance > attack_range:
		#velocity = (local_position - global_position).normalized() * move_speed
		#move_and_slide()
		#_animate(velocity.x, velocity.y)
		#return false
	#else:
		#velocity = Vector2.ZERO
		#_animate(0.0, 0.0)
		#return true


func _attack_target() -> void:
	if not is_instance_valid(target_building):
		attack_timer.stop()
		_find_target()
	
	if is_instance_valid(target_building):
		var distance_to_target = global_position.distance_to(target_building.global_position)
		
		if distance_to_target <= attack_range:
			
			# Stop moving completely during the attack strike
			_velocity = Vector2.ZERO 
			is_attacking = true
			# Play the attack animation
			$AnimationPlayer.play("attack")
			
			# Face the target while attacking
			if target_building.global_position.x < global_position.x:
				$Sprite2D.flip_h = true
			else:
				$Sprite2D.flip_h = false
			
			
			var health_component = target_building.get_node("HealthComponent")
			health_component.take_damage(attack_dmg)
			print("Attacked building for ", attack_dmg, " damage.")


func _animate(x: float, _y: float) -> void:
	if is_attacking:
		return
		
	# Check if the archer is moving horizontally
	if x < -1.0:
		$AnimationPlayer.play("run")
		$Sprite2D.flip_h = true
	elif x > 1.0:
		$AnimationPlayer.play("run")
		$Sprite2D.flip_h = false
	 
	else:
		# Only play idle if we aren't moving past our deadzone threshold
		$AnimationPlayer.play("idle")


func _on_building_placed() -> void:
	_find_target()


func _on_attack_timer_timeout() -> void:
	_attack_target()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false 
		$AnimationPlayer.play("idle")


func _on_killed() -> void:
	queue_free()
	print("Archer destroyed!")
