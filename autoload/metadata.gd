extends Node

var data: Dictionary

func _ready() -> void:
	var metadata_file: String = FileAccess.get_file_as_string("res://metadata.json")
	data = JSON.parse_string(metadata_file)
