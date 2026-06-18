extends Control

@onready var gold_label: Label = $HBoxContainer/Gold
@onready var wave_timer_label: Label = $HBoxContainer/WaveTimer


func _ready() -> void:
	GameManager.gold_changed.connect(on_gold_changed)
	update_labels()


func _process(delta: float) -> void:
	update_labels()


func update_labels() -> void:
	gold_label.text = "Gold: " + str(GameManager.gold)
	wave_timer_label.text = "Time to next wave: " + str(int(GameManager.wave_timer.time_left))


func on_gold_changed(_amount) -> void:
	update_labels()
