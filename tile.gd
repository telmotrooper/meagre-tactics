class_name Tile
extends CSGBox3D

@export_group("Materials")
@export var tile_material: Material
@export var hover_tile_material: Material
@export var walk_tile_material: Material

var walkable := false

func has_piece() -> bool:
	return len(%PieceDetector.get_overlapping_bodies()) > 0

func get_piece() -> Piece:
	return %PieceDetector.get_overlapping_bodies()[0]

func is_left_mouse_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed

func _on_area_3d_mouse_entered() -> void:
	if has_piece() and not walkable:
		material = hover_tile_material

func _on_area_3d_mouse_exited() -> void:
	if not walkable:
		material = tile_material

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_left_mouse_click(event) and has_piece():
		GameState.selected_piece = get_piece()
		#get_tree().call_group("tiles", "set_as_walkable")

func set_as_walkable() -> void:
	walkable = true
	material = walk_tile_material
