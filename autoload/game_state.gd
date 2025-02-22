extends Node

@warning_ignore("unused_signal")
signal unit_hovered
@warning_ignore("unused_signal")
signal not_hovering_any_unit
@warning_ignore("unused_signal")
signal action_consumed
@warning_ignore("unused_signal")
signal turn_ended

const TITLE_SCREEN := "res://ui/title_screen/title_screen.tscn"

@export var end_turn_sound: AudioStream

@onready var background_music_player: AudioStreamPlayer = $BackgroundMusicPlayer

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
var turn_time := 45.0

func initialize_game_state() -> void:
	current_team = "blue"
	remaining_actions = [Action.MOVE, Action.ATTACK, Action.TURN]
	current_action = Action.MOVE

func end_turn() -> void:
	current_team = "blue" if current_team == "red" else "red"
	remaining_actions = [Action.MOVE, Action.ATTACK, Action.TURN]
	set_current_unit(null)
	change_current_action(Action.MOVE)
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
	elif action == Action.ATTACK and is_action_available(Action.MOVE):
		change_current_action(Action.MOVE)
	elif is_action_available(Action.TURN):
		change_current_action(Action.TURN)
	
	action_consumed.emit(action)
	
	if len(remaining_actions) == 0 or action == Action.TURN:
		end_turn()

func change_current_action(action: Action) -> void:
	if is_action_available(action):
		current_action = action
	
	get_tree().call_group("tiles", "reset_state")
	
	if is_instance_valid(selected_unit) and is_instance_valid(selected_unit.get_tile()):
		var tile: Tile = selected_unit.get_tile()
		
		match action:
			Action.MOVE:
				selected_unit.hide_arrows()
				tile.compute_walk_tiles()
			Action.ATTACK:
				selected_unit.hide_arrows()
				tile.compute_attack_tiles()
			Action.TURN:
				selected_unit.display_arrows()

func play_sound(audio_stream: AudioStream) -> void:
	$AudioStreamPlayer.stream = audio_stream
	$AudioStreamPlayer.play()

func set_current_unit(unit: Unit) -> void:
	if is_instance_valid(selected_unit):
		selected_unit.hide_arrows()
		
	if is_instance_valid(unit) and current_action == Action.TURN:
		unit.display_arrows()
	
	selected_unit = unit
