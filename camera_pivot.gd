extends Node3D

var busy := false

func rotate_camera(degrees: float) -> void:
	if busy:
		return
	busy = true
	
	var tween := create_tween().set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(0,degrees,0), 0.5)
	tween.tween_callback(func(): busy = false)
