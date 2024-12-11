class_name Tile
extends CSGBox3D

@export_group("Materials")
@export var tile_material: Material
@export var hover_tile_material: Material
@export var walk_tile_material: Material

func _on_area_3d_mouse_entered() -> void:
	material = hover_tile_material

func _on_area_3d_mouse_exited() -> void:
	material = tile_material
