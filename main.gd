extends Node3D

func _ready() -> void:
	GameState.current_turn = "blue"
	GameState.ui.update_turn()
