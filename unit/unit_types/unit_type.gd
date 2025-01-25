class_name UnitType
extends Resource

enum MovementType { NEIGHBORING_TILES }

@export var unit_name := "Unit Name"
@export var max_hp := 10
@export var movement_type := MovementType.NEIGHBORING_TILES
@export var movement_range := 1
@export var attack_type := MovementType.NEIGHBORING_TILES
@export var attack_range := 1
