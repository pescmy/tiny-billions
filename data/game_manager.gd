extends Node
#singleton

var gold: int = 100
var current_wave: int = 100

signal gold_changed(new_gold)



func add_gold(amount: int) -> void:
	gold += amount
	gold_changed.emit()


func has_enough_gold(amount: int) -> bool:
	return gold >= amount


func spend_gold(amount: int) -> bool:
	if gold > amount:
		print("Nah bro, you poor")
		return false
		
	gold -= amount
	gold_changed.emit()
	return true
