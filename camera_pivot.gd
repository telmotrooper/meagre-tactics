extends Node3D

func rotate_camera(degrees: float) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "rotation_degrees", rotation_degrees + Vector3(0,degrees,0), 0.5)
