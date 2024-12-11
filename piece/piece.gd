class_name Piece
extends CharacterBody3D

@export var color := "blue"

@export_group("Materials")
@export var blue_material: Material
@export var red_material: Material

func _ready() -> void:
	if color == "blue":
		$MeshInstance3D3.set_surface_override_material(0, blue_material)
	elif color == "red":
		$MeshInstance3D3.set_surface_override_material(0, red_material)
