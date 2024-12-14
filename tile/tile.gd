class_name Tile
extends CSGBox3D

enum State { REGULAR, WALKABLE, HOVER }

@export_group("Materials")
@export var tile_material: Material
@export var hover_tile_material: Material
@export var walk_tile_material: Material

var state := State.REGULAR

func set_state(new_state: State) -> void:
	state = new_state
	match state:
		State.REGULAR:
			material = tile_material
		State.WALKABLE:
			material = walk_tile_material
		State.HOVER:
			material = hover_tile_material

func get_unit() -> Unit:
	return %UnitDetector.get_collider()

func has_unit() -> bool:
	return %UnitDetector.get_collider() != null

func is_left_mouse_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed

func _on_area_3d_mouse_entered() -> void:
	if has_unit() and state != State.WALKABLE:
		set_state(State.HOVER)

func _on_area_3d_mouse_exited() -> void:
	if state != State.WALKABLE:
		set_state(State.REGULAR)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_left_mouse_click(event):
		if has_unit(): # select unit
			GameState.selected_unit = get_unit()
			get_tree().call_group("tiles", "reset_state")
			for tile in get_neighboring_tiles():
				tile.set_as_walkable()
		elif state == State.WALKABLE:
			GameState.selected_unit.walk_to(self)

func reset_state() -> void:
	if state != State.HOVER:
		set_state(State.REGULAR)

func set_as_walkable() -> void:
	if not has_unit():
		set_state(State.WALKABLE)

func get_neighboring_tiles() -> Array[Tile]:
	var result: Array[Tile] = []
	
	for ray_cast in %RayCasts.get_children():
		if ray_cast.get_collider() is TileArea3D:
			result.append(ray_cast.get_collider().get_tile())
	
	return result

func enable() -> void:
	$Area3D/CollisionShape3D.disabled = false

func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true
