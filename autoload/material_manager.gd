extends Node

@export var tile_texture: Texture2D

@export_group("Materials")
@export var tile_material: Material
@export var walk_tile_material: Material
@export var attack_tile_material: Material

var hover_tile_material: Material
var hover_walk_tile_material: Material
var hover_attack_tile_material: Material

var blocked_tile_material: Material

func _ready() -> void:
	hover_tile_material = derive_material(tile_material)
	hover_walk_tile_material = derive_material(walk_tile_material)
	hover_attack_tile_material = derive_material(attack_tile_material)
	
	blocked_tile_material = derive_material(hover_tile_material, -0.4)

# Derive a brighter or darker version of an existing material.
func derive_material(existing_material: Material, factor := 0.2) -> Material:
	var new_material := StandardMaterial3D.new()
	new_material.albedo_texture = tile_texture
	
	new_material.albedo_color = Color(
		clamp(existing_material.albedo_color.r + factor, 0.0, 1.0),
		clamp(existing_material.albedo_color.g + factor, 0.0, 1.0),
		clamp(existing_material.albedo_color.b + factor, 0.0, 1.0)
	)
	
	return new_material
