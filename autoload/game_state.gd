extends Node

@warning_ignore("unused_signal")
signal unit_hovered
@warning_ignore("unused_signal")
signal not_hovering_any_unit

var board: Board
var selected_unit: Unit
var camera_pivot: CameraPivot
var ui: UI

var current_turn := "blue"

func end_turn() -> void:
	current_turn = "blue" if current_turn == "red" else "red"
	ui.update_turn()
	selected_unit = null

func play_sound(audio_stream: AudioStream) -> void:
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()
