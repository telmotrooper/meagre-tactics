@tool # Only used so we can see the unit color in the editor.
class_name Unit
extends CharacterBody3D

@export var team_color := "blue"
@export var unit_type: UnitType
@export var current_hp := 0

@export_group("Materials")
@export var blue_material: Material
@export var red_material: Material

@export_group("Sounds")
@export var moving_sound: AudioStream
@export var attacking_sound: AudioStream
@export var missing_attack_sound: AudioStream

var global_meshes := { "Body": true, "Head": true }

func _ready() -> void:
	current_hp = unit_type.max_hp
	
	var team_color_material := blue_material if team_color == "blue" else red_material
	
	for child in $Model.get_children():
		child.set_visible(false)
		
		if global_meshes.has(child.name):
			child.set_visible(true)
		elif child.name.begins_with(unit_type.unit_name):
			child.set_visible(true)
			child.set_surface_override_material(1, team_color_material)
	
	if unit_type.unit_name != "Soldier":
		$Headband.set_visible(false)
	$Headband.set_surface_override_material(0, team_color_material)

func get_tile() -> Tile:
	var collider: Object = $RayCast3D.get_collider()
	
	if collider is TileArea3D:
		return collider.get_tile()
	
	return null

func walk_to(tile: Tile) -> void:
	if team_color != GameState.current_team:
		return
	
	GameState.board.set_state(Board.State.BUSY)
	
	get_tree().call_group("tiles", "reset_state")
	var target_position := Vector3(tile.global_position.x, global_position.y, tile.global_position.z)
	look_at(target_position, Vector3.UP, true)
	var tween := create_tween()
	tween.tween_callback(func() -> void:
		$AudioStreamPlayer.stream = moving_sound
		$AudioStreamPlayer.play()
	)
	# TODO: In the future use distance in number of tiles to calculate time.
	tween.tween_property(self, "global_position", target_position, 0.5)
	tween.tween_callback(func() -> void:
		$AudioStreamPlayer.stop()
		GameState.consume_action(GameState.Action.MOVE)
		GameState.board.set_state(Board.State.IDLE)
	)

func attack(tile: Tile) -> void:
	GameState.board.set_state(Board.State.BUSY)
	
	get_tree().call_group("tiles", "reset_state")
	var target_position := Vector3(tile.global_position.x, global_position.y, tile.global_position.z)
	look_at(target_position, Vector3.UP, true)
	var tween := create_tween()
	tween.tween_callback(func() -> void:
		$AudioStreamPlayer.stream = attacking_sound if tile.get_unit() else missing_attack_sound
		$AudioStreamPlayer.play()
		
		if tile.get_unit():
			tile.get_unit().queue_free()
		
		await $AudioStreamPlayer.finished
		
		GameState.consume_action(GameState.Action.ATTACK)
		GameState.board.set_state(Board.State.IDLE)
	)

func display_arrows() -> void:
	var enabled: bool = (team_color == GameState.current_team)
	
	for arrow in $Arrows.get_children():
		arrow.set_enabled(enabled)
	
	$Arrows.set_visible(true)

func hide_arrows() -> void:
	$Arrows.set_visible(false)

func _on_arrow_clicked(arrow: Node3D) -> void:
	if team_color == GameState.current_team:
		GameState.consume_action(GameState.Action.TURN)
		rotation_degrees.y += arrow.rotation_degrees.y
