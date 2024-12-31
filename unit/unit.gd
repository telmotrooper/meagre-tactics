@tool # Only used so we can see the unit color in the editor.
class_name Unit
extends CharacterBody3D

@export var team_color := "blue"
@export var unit_type: UnitType
@export var current_hp := 0

@export_group("Materials")
@export var blue_material: Material
@export var red_material: Material

func _ready() -> void:
	current_hp = unit_type.max_hp
	
	if team_color == "blue":
		$Headband.set_surface_override_material(0, blue_material)
	elif team_color == "red":
		$Headband.set_surface_override_material(0, red_material)

func walk_to(tile: Tile) -> void:
	if team_color != GameState.current_team:
		return
	
	GameState.board.set_state(Board.State.BUSY)
	
	get_tree().call_group("tiles", "reset_state")
	var target_position = Vector3(tile.global_position.x, global_position.y, tile.global_position.z)
	look_at(target_position, Vector3.UP, true)
	var tween = create_tween()
	tween.tween_callback($AudioStreamPlayer.play)
	# TODO: In the future use distance in number of tiles to calculate time.
	tween.tween_property(self, "global_position", target_position, 0.5)
	tween.tween_callback(func():
		$AudioStreamPlayer.stop()
		GameState.board.set_state(Board.State.IDLE)
		GameState.consume_action(GameState.Action.MOVE)
	)

func attack(tile: Tile) -> void:
	GameState.board.set_state(Board.State.BUSY)
	
	get_tree().call_group("tiles", "reset_state")
	var target_position = Vector3(tile.global_position.x, global_position.y, tile.global_position.z)
	look_at(target_position, Vector3.UP, true)
	var tween = create_tween()
	#tween.tween_callback($AudioStreamPlayer.play)
	tween.tween_callback(func():
		$AudioStreamPlayer.stop()
		
		# TODO: Perform actual hit calculation here instead of deleting unit.
		if tile.get_unit():
			tile.get_unit().queue_free()
		
		GameState.board.set_state(Board.State.IDLE)
		GameState.consume_action(GameState.Action.ATTACK)
	)
