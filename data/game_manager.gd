extends Node
#singleton

var gold: int = 10000

var current_wave: int = 0

var wave_timer: Timer
var time_between_waves: float = 10.0
var number_of_enemies: int = 5
var base_enemies: int = 5
var enemies_per_wave_scaling: int = 3



signal gold_changed(new_gold)
signal start_of_wave(number_of_enemies)


func _ready() -> void:
	wave_timer = Timer.new()
	add_child(wave_timer)
	wave_timer.wait_time = time_between_waves
	wave_timer.autostart = true
	wave_timer.timeout.connect(_on_wave_timer_timeout)
	wave_timer.start()


func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)


func has_enough_gold(amount: int) -> bool:
	return gold >= amount


func spend_gold(amount: int) -> bool:
	if gold < amount:
		print("Nah bro, you poor")
		return false
		
	gold -= amount
	gold_changed.emit(gold)
	return true


func wave_start() -> void:
	current_wave += 1
	number_of_enemies = base_enemies + (current_wave * enemies_per_wave_scaling)
	start_of_wave.emit(number_of_enemies)


func _on_wave_timer_timeout() -> void:
	wave_start()
	
