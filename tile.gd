class_name Tile
extends CSGBox3D

@export_group("Materials")
@export var tile_material: Material
@export var hover_tile_material: Material
@export var walk_tile_material: Material

func _on_area_3d_mouse_entered() -> void:
	if len($Area3D2.get_overlapping_bodies()) > 0:
		material = hover_tile_material

func _on_area_3d_mouse_exited() -> void:
	material = tile_material
