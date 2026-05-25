extends Control

@onready var gold_label: Label = $HBoxContainer/Gold



func _ready() -> void:
	GameManager.gold_changed.connect(on_gold_changed)


func _process(delta: float) -> void:
	pass


func update_labels() -> void:
	gold_label.text = "Gold: " + str(GameManager.gold)
	pass


func on_gold_changed(amount) -> void:
	update_labels()

#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.pressed:
		#match event.keycode:
			#KEY_QUOTELEFT:
				#visible = not visible
