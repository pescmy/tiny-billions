extends Control

@onready var build_mode_label: Label = $MarginContainer/VBoxContainer/BuildMode
@onready var build_validity_label: Label = $MarginContainer/VBoxContainer/BuildValidity
@onready var king_position_label: Label = $MarginContainer/VBoxContainer/KingPosition
@onready var mouse_grid_position_label: Label = $MarginContainer/VBoxContainer/MouseGridPosition

func _ready() -> void:
	update_labels()
	hide()


func _process(delta: float) -> void:
	update_labels()


func update_labels() -> void:
	build_mode_label.text = "Build Mode: " + str(BuildManager.in_build_mode)
	build_validity_label.text = "Build Valid: " + str(BuildManager.build_in_king_radius)
	king_position_label.text = "King Position: " + str(BuildManager.king_global_position)
	mouse_grid_position_label.text = "Mouse Grid Position: " + str(GridHelper.world_to_grid(get_global_mouse_position()))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_QUOTELEFT:
				visible = not visible
