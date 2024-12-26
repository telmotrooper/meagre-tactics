extends Node3D

@export var practice_scene: PackedScene

func _on_practice_button_pressed() -> void:
	enter_dungeon()

func enter_dungeon():
	var tween := create_tween()
	tween.tween_property($Control, "modulate", Color.hex(0xffffff00), 1.0)
	tween.tween_property($Node3D/Camera3D, "position", Vector3(0,3,-8),3.5)
	tween.tween_callback(func():
		SceneChanger.change_scene(practice_scene.get_path())
	)
