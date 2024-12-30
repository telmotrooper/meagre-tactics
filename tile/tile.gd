class_name Tile
extends CSGBox3D

enum State { REGULAR, REGULAR_HOVER, WALKABLE, WALKABLE_HOVER, ATTACKABLE, ATTACKABLE_HOVER }

@export var unit_selected_sound: AudioStream

@onready var ray_casts = %RayCasts

var state := State.REGULAR
var reached_through_enemy_tile = null

func set_state(new_state: State) -> void:
	state = new_state
	match state:
		State.REGULAR:
			material = MaterialManager.tile_material
		State.REGULAR_HOVER:
			material = MaterialManager.hover_tile_material
		State.WALKABLE:
			if is_instance_valid(GameState.selected_unit) and GameState.selected_unit.color != GameState.current_team:
				material = MaterialManager.blocked_walk_tile_material
			else:
				material = MaterialManager.walk_tile_material
		State.WALKABLE_HOVER:
			material = MaterialManager.hover_walk_tile_material
		State.ATTACKABLE:
			material = MaterialManager.debug_tile_material
		State.ATTACKABLE_HOVER:
			material = MaterialManager.debug_tile_material

func get_unit() -> Unit:
	return %UnitDetector.get_collider()

func has_unit() -> bool:
	return %UnitDetector.get_collider() != null

func has_enemy_unit(tile: Tile) -> bool:
	return tile.get_unit() and tile.get_unit().color != get_unit().color

func is_walkable(tile: Tile) -> bool:
	return tile.state == State.WALKABLE or tile.state == State.WALKABLE_HOVER

func has_walkable_neighbors() -> bool:
	var neighboring_tiles = get_neighboring_tiles(self)
	return neighboring_tiles.any(func(tile): return is_walkable(tile) and not tile.reached_through_enemy_tile)

func is_left_mouse_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed

func _on_area_3d_mouse_entered() -> void:
	if has_unit() and state != State.WALKABLE:
		set_state(State.REGULAR_HOVER)
		GameState.unit_hovered.emit(get_unit())
	elif state == State.WALKABLE and is_instance_valid(GameState.selected_unit) and GameState.selected_unit.color == GameState.current_team:
		set_state(State.WALKABLE_HOVER)
	else:
		GameState.not_hovering_any_unit.emit()

func _on_area_3d_mouse_exited() -> void:
	if state == State.WALKABLE_HOVER:
		set_state(State.WALKABLE)
	elif state != State.WALKABLE:
		set_state(State.REGULAR)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_left_mouse_click(event):
		if has_unit(): # Select unit
			GameState.play_sound(unit_selected_sound)
			GameState.selected_unit = get_unit()
			get_tree().call_group("tiles", "reset_state")
			
			var unit_type = get_unit().unit_type
			
			if unit_type.movement_type == unit_type.MovementType.NEIGHBORING_TILES:
				var tiles: Array[Tile] = [self]
				
				var affected_tiles: Array[Tile] = []
				
				for _i in unit_type.movement_range:
					var neighboring_tiles: Array[Tile] = []
					
					for tile in tiles:
						var new_tiles := get_neighboring_tiles(tile)
						
						for new_tile in new_tiles:
							# "null" means not calculate, "true" means calculated once
							if tile.reached_through_enemy_tile:
								new_tile.reached_through_enemy_tile = true
							elif not has_enemy_unit(new_tile) and (new_tile.reached_through_enemy_tile == null or new_tile.reached_through_enemy_tile == true):
								new_tile.reached_through_enemy_tile = has_enemy_unit(tile)
						
						neighboring_tiles.append_array(new_tiles)

					for neighboring_tile in neighboring_tiles:
						if neighboring_tile != self and not affected_tiles.has(neighboring_tile): # Not ideal to iterate the array every time.
							affected_tiles.append(neighboring_tile)
							neighboring_tile.set_as_walkable()
					
					# Update list of tiles for next iteration.
					tiles = neighboring_tiles
				
				for _i in range(2): # Iterate twice cleaning up "reached_through_enemy_tile".
					for affected_tile in affected_tiles:
						if affected_tile.reached_through_enemy_tile and affected_tile.has_walkable_neighbors():
							affected_tile.reached_through_enemy_tile = false
					
				for affected_tile in affected_tiles:
					if affected_tile.reached_through_enemy_tile:
						affected_tile.reset_state()
		
		elif state == State.WALKABLE_HOVER and is_instance_valid(GameState.selected_unit) and GameState.is_action_available(GameState.Action.MOVE):
			GameState.selected_unit.walk_to(self)
		
		else: # Clean up selection
			GameState.selected_unit = null
			GameState.not_hovering_any_unit.emit()
			get_tree().call_group("tiles", "reset_state")

func reset_state() -> void:
	reached_through_enemy_tile = null
	if state != State.REGULAR_HOVER:
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
