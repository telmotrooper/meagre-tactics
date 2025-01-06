extends Node3D

func _ready() -> void:
	GameState.initialize_game_state()
	GameState.ui.update_turn()
