extends Node
#singleton

var gold: int = 10000

var current_wave: int = 0
var time_between_waves: float = 1

signal gold_changed(new_gold)



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

	
	
