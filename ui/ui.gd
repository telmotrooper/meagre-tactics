class_name UI
extends Control

@export var button_click_sound: AudioStream

var progress_bar_fill: StyleBoxFlat = load("res://ui/progress_bar_fill.tres")

const text = "%s (%s)\nHP: %d/%d"

func _ready() -> void:
	GameState.ui = self
	
	$TurnTimer.wait_time = GameState.turn_time
	
	if not is_instance_valid(GameState.camera_pivot):
		print("Error: Camera pivot not found.")
	
	%CameraButtons/LeftButton.pressed.connect(GameState.camera_pivot.rotate_camera.bind(-90.0))
	%CameraButtons/RightButton.pressed.connect(GameState.camera_pivot.rotate_camera.bind(90.0))
	
	%SelectedUnitOverview.text = ""
	%MoveButton.grab_focus()
	
	GameState.unit_hovered.connect(update_unit_overview)
	GameState.not_hovering_any_unit.connect(fallback_overview)
	GameState.action_consumed.connect(disable_action_button)
	GameState.turn_ended.connect(update_turn)
	
	%TurnButtons/EndTurnButton.pressed.connect(GameState.end_turn)

func update_unit_overview(unit: Unit) -> void:
	%SelectedUnitOverview.text = text % [unit.unit_type.unit_name, unit.team_color.capitalize(), unit.current_hp, unit.unit_type.max_hp]

func fallback_overview() -> void:
	if is_instance_valid(GameState.selected_unit):
		update_unit_overview(GameState.selected_unit)
	else:
		%SelectedUnitOverview.text = ""

func update_turn() -> void:
	progress_bar_fill.bg_color = GameState.team_color[GameState.current_team]
	%TurnIndicator.text = "Turn: %s" % GameState.current_team.capitalize()
	$TurnTimer.start()
	_on_tick_timer_timeout() # Force instant refresh.
	
	for turn_button in %TurnButtons.get_children():
		turn_button.disabled = false
	
	%MoveButton.grab_focus()

func _on_tick_timer_timeout() -> void:
	%TimeLeftIndicator.value = $TurnTimer.time_left * 100 / $TurnTimer.wait_time

func _on_turn_timer_timeout() -> void:
	GameState.end_turn()

func _on_move_button_pressed() -> void:
	GameState.play_sound(button_click_sound)
	GameState.change_current_action(GameState.Action.MOVE)

func _on_attack_button_pressed() -> void:
	GameState.play_sound(button_click_sound)
	GameState.change_current_action(GameState.Action.ATTACK)

func _on_turn_button_pressed() -> void:
	GameState.play_sound(button_click_sound)
	GameState.change_current_action(GameState.Action.TURN)

func _on_settings_button_pressed() -> void:
	GameState.play_sound(button_click_sound)

func _on_surrender_button_pressed() -> void:
	GameState.play_sound(button_click_sound)
	$SurrenderDialog.show()

func _on_surrender_dialog_confirmed() -> void:
	GameState.play_sound(button_click_sound)
	SceneChanger.change_scene(GameState.TITLE_SCREEN)

func _on_surrender_dialog_canceled() -> void:
	GameState.play_sound(button_click_sound)

func disable_action_button(action: GameState.Action) -> void:
	match action:
		GameState.Action.MOVE:
			%MoveButton.disabled = true
		GameState.Action.ATTACK:
			%AttackButton.disabled = true
		_:
			print("Error: Action unmapped.")
	
	match GameState.current_action:
		GameState.Action.ATTACK:
			%AttackButton.grab_focus()
		GameState.Action.TURN:
			%TurnButton.grab_focus()
