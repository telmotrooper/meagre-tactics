extends Node3D

@export var practice_scene: PackedScene

func _on_practice_button_pressed() -> void:
	get_tree().change_scene_to_packed(practice_scene)
