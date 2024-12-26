extends Control

signal faded_in
signal faded_out

@export var duration = 0.5 # seconds

func _ready() -> void:
	fade_in()

func change_scene(path: String) -> void:
	fade_out()
	await faded_out
	get_tree().change_scene_to_file(path)
	fade_in()

func fade_in() -> void:
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0,0,0,0), duration) # transparent
	tween.tween_callback(func():
		hide()
		faded_in.emit()
	)

func fade_out() -> void:
	show()
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate", Color(0,0,0,1), duration) # black
	tween.tween_callback(func(): faded_out.emit())
