@tool # Only used so we can see the unit color in the editor.
class_name Unit
extends CharacterBody3D

@export var color := "blue"
@export var unit_type: UnitType

@export_group("Materials")
@export var blue_material: Material
@export var red_material: Material

func _ready() -> void:
	if color == "blue":
		$Headband.set_surface_override_material(0, blue_material)
	elif color == "red":
		$Headband.set_surface_override_material(0, red_material)

func walk_to(tile: Tile) -> void:
	GameState.board.set_state(Board.State.BUSY)
	
	get_tree().call_group("tiles", "reset_state")
	var target_position = Vector3(tile.global_position.x, global_position.y, tile.global_position.z)
	look_at(target_position, Vector3.UP, true)
	var tween = create_tween()
	# TODO: In the future use distance in number of tiles to calculate time.
	tween.tween_property(self, "global_position", target_position, 0.5)
	
	tween.tween_callback(GameState.board.set_state.bind(Board.State.IDLE))
	
