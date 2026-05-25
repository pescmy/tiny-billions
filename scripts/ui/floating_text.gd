extends Control

var duration: float = 1.0


func _ready() -> void:
	flash_floating_label()


func flash_floating_label() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position:y", position.y - 40, duration)
	# 2. Fade out the opacity (modulate alpha)
	tween.tween_property(self, "modulate:a", 0.0, duration)
	
	# 3. Automatically destroy the label when the animations finish
	tween.chain().tween_callback(queue_free)
