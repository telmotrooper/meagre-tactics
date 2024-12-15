class_name Tile
extends CSGBox3D

enum State { REGULAR, WALKABLE, HOVER }

@export_group("Materials")
@export var tile_material: Material
@export var hover_tile_material: Material
@export var walk_tile_material: Material

@onready var ray_casts = %RayCasts

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
		GameState.unit_hovered.emit(get_unit())
	else:
		GameState.not_hovering_any_unit.emit()

func _on_area_3d_mouse_exited() -> void:
	if state != State.WALKABLE:
		set_state(State.REGULAR)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_left_mouse_click(event):
		if has_unit(): # Select unit
			GameState.selected_unit = get_unit()
			get_tree().call_group("tiles", "reset_state")
			
			var unit_type = get_unit().unit_type
			
			if unit_type.movement_type == unit_type.MovementType.NEIGHBORING_TILES:
				var tiles: Array[Tile] = [self] 
				
				for i in unit_type.movement_range:
					var neighboring_tiles: Array[Tile] = []
					
					for tile in tiles:
						neighboring_tiles.append_array(get_neighboring_tiles(tile))
					
					for neighboring_tile in neighboring_tiles:
						neighboring_tile.set_as_walkable()
					
					# Update list of tiles for next iteration.
					tiles = neighboring_tiles
		
		elif state == State.WALKABLE:
			GameState.selected_unit.walk_to(self)
		
		else: # Clean up selection
			GameState.selected_unit = null
			GameState.not_hovering_any_unit.emit()
			get_tree().call_group("tiles", "reset_state")

func reset_state() -> void:
	if state != State.HOVER:
		set_state(State.REGULAR)

func set_as_walkable() -> void:
	if not has_unit():
		set_state(State.WALKABLE)

func get_neighboring_tiles(tile: Tile) -> Array[Tile]:
	var result: Array[Tile] = []
	
	for ray_cast in tile.ray_casts.get_children():
		if ray_cast.get_collider() is TileArea3D:
			result.append(ray_cast.get_collider().get_tile())
	
	return result

func enable() -> void:
	$Area3D/CollisionShape3D.disabled = false

func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true
