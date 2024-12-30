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

enum Action { WALK, ATTACK, TURN }

const team_color := {
	"blue": "#384962",
	"red": "#c44836"
}

var current_team := "blue"
var remaining_actions := [Action.WALK, Action.ATTACK, Action.TURN]

func end_turn() -> void:
	current_team = "blue" if current_team == "red" else "red"
	remaining_actions = [Action.WALK, Action.ATTACK, Action.TURN]
	ui.update_turn()
	selected_unit = null
	play_sound(end_turn_sound)

func consume_action(action: Action) -> void:
	if remaining_actions.has(action):
		remaining_actions.erase(action)
	if len(remaining_actions) == 0:
		end_turn()

func play_sound(audio_stream: AudioStream) -> void:
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()
