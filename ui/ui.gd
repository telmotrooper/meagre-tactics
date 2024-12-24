class_name UI
extends Control

const text = "%s (%s)\nHP: %d/%d"

func _ready() -> void:
	GameState.ui = self
	
	if not is_instance_valid(GameState.camera_pivot):
		print("Error: Camera pivot not found.")
	
	%CameraButtons/LeftButton.pressed.connect(GameState.camera_pivot.rotate_camera.bind(-90.0))
	%CameraButtons/RightButton.pressed.connect(GameState.camera_pivot.rotate_camera.bind(90.0))
	
	%SelectedUnitOverview.text = ""
	%TurnButtons.get_children()[0].grab_focus()
	GameState.unit_hovered.connect(update_unit_overview)
	GameState.not_hovering_any_unit.connect(fallback_overview)

func update_unit_overview(unit: Unit) -> void:
	%SelectedUnitOverview.text = text % [unit.unit_type.unit_name, unit.color.capitalize(), unit.current_hp, unit.unit_type.max_hp]

func fallback_overview() -> void:
	if GameState.selected_unit:
		update_unit_overview(GameState.selected_unit)
	else:
		%SelectedUnitOverview.text = ""

func update_turn() -> void:
	%TurnIndicator.text = "Turn: %s" % GameState.current_turn.capitalize()
	$TurnTimer.start()
	_on_tick_timer_timeout() # Force instant refresh.

func _on_tick_timer_timeout() -> void:
	%TimeLeftIndicator.value = $TurnTimer.time_left * 100 / $TurnTimer.wait_time

func _on_turn_timer_timeout() -> void:
	GameState.end_turn()
