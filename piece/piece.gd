class_name Piece
extends CharacterBody3D

@export var color := "blue"

@export_group("Materials")
@export var blue_material: Material
@export var red_material: Material

func _ready() -> void:
	if color == "blue":
		$Headband.set_surface_override_material(0, blue_material)
	elif color == "red":
		$Headband.set_surface_override_material(0, red_material)

func walk_to(tile: Tile) -> void:
	var target_position = Vector3(tile.global_position.x, global_position.y ,tile.global_position.z)
	global_position = target_position
	print("%s walk to %s" % [name, tile])
	
