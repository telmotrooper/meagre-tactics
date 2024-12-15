extends Control

const text = "%s\nHP: %d/%d"

func _ready() -> void:
	GameState.unit_hovered.connect(update_unit_overview)

func update_unit_overview(unit: Unit) -> void:
	%SelectedUnitOverview.text = text % [unit.unit_type.unit_name, unit.current_hp, unit.unit_type.max_hp]