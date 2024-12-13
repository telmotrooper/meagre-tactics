class_name Tile
extends CSGBox3D

@export_group("Materials")
@export var tile_material: Material
@export var hover_tile_material: Material
@export var walk_tile_material: Material

enum State { REGULAR, WALKABLE, HOVER }

var state := State.REGULAR

func has_piece() -> bool:
	return %PieceDetector.get_collider() != null

func get_piece() -> Piece:
	return %PieceDetector.get_collider() 

func is_left_mouse_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed

func _on_area_3d_mouse_entered() -> void:
	if has_piece() and state != State.WALKABLE:
		state = State.HOVER
		material = hover_tile_material

func _on_area_3d_mouse_exited() -> void:
	if state != State.WALKABLE:
		material = tile_material

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_left_mouse_click(event) and has_piece():
		GameState.selected_piece = get_piece()
		get_tree().call_group("tiles", "reset_mode")
		for ray_cast in %RayCasts.get_children():
			if ray_cast.get_collider() is TileArea3D:
				ray_cast.get_collider().get_tile().set_as_walkable()

func reset_mode() -> void:
	if state != State.HOVER:
		state = State.REGULAR
		material = tile_material

func set_as_walkable() -> void:
	if not has_piece():
		state = State.WALKABLE
		material = walk_tile_material
