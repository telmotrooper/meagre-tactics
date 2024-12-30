extends Node3D

func _ready() -> void:
	GameState.current_team = "blue"
	GameState.ui.update_turn()
