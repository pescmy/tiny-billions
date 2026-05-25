extends Control

@onready var gold_label: Label = $HBoxContainer/Gold



func _ready() -> void:
	GameManager.gold_changed.connect(on_gold_changed)
	update_labels()


func update_labels() -> void:
	gold_label.text = "Gold: " + str(GameManager.gold)


func on_gold_changed(_amount) -> void:
	update_labels()
