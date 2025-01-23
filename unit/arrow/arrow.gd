extends Node3D

signal clicked

@export var regular_material: Material
@export var blocked_material: Material
@export var highlight_shader_material: ShaderMaterial

@onready var model: MeshInstance3D = $arrow/Plane_001

func _ready() -> void:
	# Make materials unique to the instance.
	regular_material = regular_material.duplicate()
	blocked_material = blocked_material.duplicate()
	
	$arrow/Plane.mouse_entered.connect(_on_mouse_entered)
	$arrow/Plane.mouse_exited.connect(_on_mouse_exited)
	$arrow/Plane.input_event.connect(_on_input_event)

func _on_mouse_entered() -> void:
	if model.get_active_material(0) == regular_material:
		model.get_active_material(0).next_pass = highlight_shader_material

func _on_mouse_exited() -> void:
	model.get_active_material(0).next_pass = null

func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if Utils.is_left_mouse_click(event):
		clicked.emit(self)

func set_enabled(enabled: bool) -> void:
	var material := regular_material if enabled else blocked_material
	model.set_surface_override_material(0, material)
