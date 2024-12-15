extends Control

const text = "%s (%s)\nHP: %d/%d"

func _ready() -> void:
	GameState.unit_hovered.connect(update_unit_overview)
	GameState.not_hovering_any_unit.connect(fallback_overview)

func update_unit_overview(unit: Unit) -> void:
	%SelectedUnitOverview.text = text % [unit.unit_type.unit_name, unit.color.capitalize(), unit.current_hp, unit.unit_type.max_hp]

func fallback_overview() -> void:
	if GameState.selected_unit:
		update_unit_overview(GameState.selected_unit)
	else:
		%SelectedUnitOverview.text = ""
