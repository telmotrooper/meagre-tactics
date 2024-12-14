class_name Board
extends Node3D

enum State { IDLE, BUSY }

var state := State.IDLE

func _ready() -> void:
	GameState.board = self

func set_state(new_state: State) -> void:
	state = new_state
	match state:
		State.IDLE:
			get_tree().call_group("tiles", "enable")
		State.BUSY:
			get_tree().call_group("tiles", "disable")
