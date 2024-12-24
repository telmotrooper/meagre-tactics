extends Node

@warning_ignore("unused_signal")
signal unit_hovered
@warning_ignore("unused_signal")
signal not_hovering_any_unit

var board: Board
var selected_unit: Unit
var camera_pivot: CameraPivot

var current_turn := "blue"
