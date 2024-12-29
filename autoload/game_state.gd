extends Node

@warning_ignore("unused_signal")
signal unit_hovered
@warning_ignore("unused_signal")
signal not_hovering_any_unit

const TITLE_SCREEN := "res://ui/title_screen/title_screen.tscn"

@export var end_turn_sound: AudioStream

var progress_bar_fill: StyleBoxFlat = load("res://ui/progress_bar_fill.tres")

var board: Board
var selected_unit: Unit
var camera_pivot: CameraPivot
var ui: UI

const team_colors := {
	"blue": "#384962",
	"red": "#c44836"
}

var current_turn := "blue"

func end_turn() -> void:
	current_turn = "blue" if current_turn == "red" else "red"
	progress_bar_fill.bg_color = team_colors[current_turn]
	ui.update_turn()
	selected_unit = null
	play_sound(end_turn_sound)

func play_sound(audio_stream: AudioStream) -> void:
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()
