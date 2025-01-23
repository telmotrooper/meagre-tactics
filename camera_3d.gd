extends Camera3D

@export var zoom_speed := 0.1
@export var pan_speed := 0.025
@export var rotation_speed := 1.0

@export var can_pan: bool
@export var can_zoom: bool

var touch_points: Dictionary = {}

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)

func handle_touch(event: InputEventScreenTouch) -> void:
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)

func handle_drag(event: InputEventScreenDrag) -> void:
	touch_points[event.index] = event.position
	
	if touch_points.size() == 1:
		if can_pan:
			h_offset -= event.relative.x * pan_speed
			v_offset += event.relative.y * pan_speed
