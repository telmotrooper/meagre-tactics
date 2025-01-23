class_name CameraPivot
extends Node3D

@export var sound_effect_left: AudioStream
@export var sound_effect_right: AudioStream

var busy := false

func _ready() -> void:
	GameState.camera_pivot = self

func rotate_camera(degrees: float) -> void:
	if busy:
		return
	busy = true
	
	var sound_effect := sound_effect_right if degrees >= 0 else sound_effect_left
	GameState.play_sound(sound_effect)
	
	var tween := create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(0,degrees,0), 0.5)
	tween.tween_callback(func() -> void: busy = false)
