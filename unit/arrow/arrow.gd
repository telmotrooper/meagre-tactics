extends Node3D

signal clicked

func _ready() -> void:
	$arrow/Plane.mouse_entered.connect(_on_mouse_entered)
	$arrow/Plane.mouse_exited.connect(_on_mouse_exited)
	$arrow/Plane.input_event.connect(_on_input_event)

func _on_mouse_entered() -> void:
	pass

func _on_mouse_exited() -> void:
	pass

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if Utils.is_left_mouse_click(event):
		clicked.emit(self)

func set_material(material: Material) -> void:
	$arrow/Plane_001.set_surface_override_material(0, material)