extends Node3D

@export var practice_scene: PackedScene

func _on_practice_button_pressed() -> void:
	SceneChanger.change_scene(practice_scene.get_path())
