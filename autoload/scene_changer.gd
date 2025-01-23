extends Control

signal faded_in
signal faded_out

const FALLBACK_SCENE := "res://game.tscn"

@export var duration := 0.5 # seconds

func _ready() -> void:
	fade_in()
	
	if not is_instance_valid(get_viewport().get_camera_3d()):
		print("Scene \"%s\" has no camera, loading fallback scene instead." % get_tree().current_scene.name)
		get_tree().call_deferred("change_scene_to_file", FALLBACK_SCENE)

func change_scene(path: String) -> void:
	fade_out()
	await faded_out
	get_tree().change_scene_to_file(path)
	fade_in()

func fade_in() -> void:
	var tween := create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0,0,0,0), duration) # transparent
	tween.tween_callback(func() -> void:
		hide()
		faded_in.emit()
	)

func fade_out() -> void:
	show()
	var tween := create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0,0,0,1), duration) # black
	tween.tween_callback(func() -> void: faded_out.emit())
