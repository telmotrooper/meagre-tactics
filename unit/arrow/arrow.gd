extends Node3D

func _ready() -> void:
	$arrow/Plane.mouse_entered.connect(_on_mouse_entered)
	$arrow/Plane.mouse_exited.connect(_on_mouse_exited)
	$arrow/Plane.input_event.connect(_on_input_event)

func _on_mouse_entered() -> void:
	print("_on_mouse_entered")

func _on_mouse_exited() -> void:
	print("_on_mouse_exited")

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		print("arrow clicked")
