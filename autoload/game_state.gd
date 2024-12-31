extends Node

@warning_ignore("unused_signal")
signal unit_hovered
@warning_ignore("unused_signal")
signal not_hovering_any_unit
@warning_ignore("unused_signal")
signal action_consumed
@warning_ignore("unused_signal")
signal turn_ended
@warning_ignore("unused_signal")
signal action_changed

const TITLE_SCREEN := "res://ui/title_screen/title_screen.tscn"

@export var end_turn_sound: AudioStream

var board: Board
var selected_unit: Unit
var camera_pivot: CameraPivot
var ui: UI

enum Action { MOVE, ATTACK, TURN }

const team_color := {
	"blue": "#384962",
	"red": "#c44836"
}

var current_team := "blue"
var remaining_actions := [Action.MOVE, Action.ATTACK, Action.TURN]
var current_action := Action.MOVE

func end_turn() -> void:
	current_team = "blue" if current_team == "red" else "red"
	remaining_actions = [Action.MOVE, Action.ATTACK, Action.TURN]
	change_current_action(Action.MOVE)
	selected_unit = null
	play_sound(end_turn_sound)
	turn_ended.emit()

func is_action_available(action: Action) -> bool:
	return remaining_actions.has(action)

func consume_action(action: Action) -> void:
	if not is_action_available(action):
		print("Error: Attempting to consume unavailable action.")
		return
	
	remaining_actions.erase(action)
	
	if action == Action.MOVE and is_action_available(Action.ATTACK):
		change_current_action(Action.ATTACK)
	elif action == Action.ATTACK and is_action_available(Action.TURN):
		change_current_action(Action.TURN)
	
	action_consumed.emit(action)
	
	if len(remaining_actions) == 0:
		end_turn()

func change_current_action(action: Action) -> void:
	if is_action_available(action):
		current_action = action
	action_changed.emit()

func play_sound(audio_stream: AudioStream) -> void:
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()
