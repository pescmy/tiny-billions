extends Node2D
#class_name BuildingShake


#func _ready() -> void:
	#shake()



func shake() -> void:
	var tween = create_tween()

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(get_parent(), "rotation_degrees", 3.0, 0.1)
	tween.tween_property(get_parent(), "rotation_degrees", -3.0, 0.1)
	tween.tween_property(get_parent(), "rotation", 0, 0.1)
	
