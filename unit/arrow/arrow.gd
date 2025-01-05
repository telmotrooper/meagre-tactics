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
	if Utils.is_left_mouse_click(event):
		GameState.consume_action(GameState.Action.TURN)
