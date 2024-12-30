extends Node

@warning_ignore("unused_signal")
signal unit_hovered
@warning_ignore("unused_signal")
signal not_hovering_any_unit

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
	current_action = Action.MOVE
	ui.update_turn()
	selected_unit = null
	play_sound(end_turn_sound)

func is_action_available(action: Action) -> bool:
	return remaining_actions.has(action)

func consume_action(action: Action) -> void:
	if not is_action_available(action):
		print("Error: Attempting to consume unavailable action.")
		return
	
	remaining_actions.erase(action)
	
	if len(remaining_actions) == 0:
		end_turn()

func play_sound(audio_stream: AudioStream) -> void:
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()
