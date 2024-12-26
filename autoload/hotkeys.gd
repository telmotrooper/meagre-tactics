extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_toggle_fullscreen"):
		toggle_fullscreen()

func toggle_fullscreen() -> void:
	get_window().mode = Window.MODE_FULLSCREEN if get_window().mode == Window.MODE_WINDOWED else Window.MODE_WINDOWED
