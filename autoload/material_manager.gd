extends Node

@export_group("Materials")
@export var tile_material: Material
@export var walk_tile_material: Material
@export var debug_tile_material: Material

var hover_tile_material: Material
var hover_walk_tile_material: Material

func _ready() -> void:
	hover_tile_material = derive_material(tile_material)
	hover_walk_tile_material = derive_material(walk_tile_material)

func derive_material(existing_material: Material, factor := 0.2) -> Material:
	# Derive a brighter version of an existing material, to be used when hovering a tile.
	var new_material = StandardMaterial3D.new()
	new_material.albedo_texture = load("res://tile/tile_texture.png")
	
	new_material.albedo_color = Color(
		existing_material.albedo_color.r + factor,
		existing_material.albedo_color.g + factor,
		existing_material.albedo_color.b + factor
	)
	
	return new_material
