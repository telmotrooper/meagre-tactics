extends Node3D

@export var practice_scene: PackedScene

@export_group("Icons")
@export var volume_on_icon: Texture2D
@export var volume_off_icon: Texture2D

func _ready() -> void:
	read_build_label()
	update_volume_button()
	
	if OS.has_feature("web"):
		%QuitButton.queue_free() # No point in having a "Quit" button in a web app.
	
	if not OS.has_feature("web_android") and not OS.has_feature("web_ios"):
		%InviteButton.queue_free() # No point in displaying a QR Code if not on mobile.
	
	for panel in %Panels.get_children():
		panel.hide()
	
	%MainPanel.show()

func read_build_label() -> void:
	if Metadata.data.build:
		%BuildLabel.text = "Build: %s" % Metadata.data.build

func update_volume_button() -> void:
	if GameState.background_music_player.playing:
		%VolumeButton.icon = volume_on_icon
	else:
		%VolumeButton.icon = volume_off_icon

func _on_practice_button_pressed() -> void:
	enter_dungeon()

# Disable buttons during transition.
func disable_buttons() -> void:
	const MOUSE_FILTER_IGNORE = 2
	
	for button in %MainPanel/VBoxContainer.get_children():
		button.mouse_filter = MOUSE_FILTER_IGNORE
	
	%ToggleFullscreenButton.mouse_filter = MOUSE_FILTER_IGNORE

func enter_dungeon() -> void:
	var tween := create_tween()
	tween.tween_callback(func() -> void:
		$Control/AudioStreamPlayer.play()
		disable_buttons()
	)
	tween.tween_property($Control, "modulate", Color.hex(0xffffff00), 1.0)
	tween.tween_property($Node3D/Camera3D, "position", Vector3(0,3,-8),3.5)
	tween.tween_callback(func() -> void:
		SceneChanger.change_scene(practice_scene.get_path())
	)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_toggle_fullscreen_button_pressed() -> void:
	Hotkeys.toggle_fullscreen()

func _on_volume_button_pressed() -> void:
	if GameState.background_music_player.playing:
		GameState.background_music_player.stop()
	else:
		GameState.background_music_player.play()
	update_volume_button()

func _on_play_button_pressed() -> void:
	enter_dungeon()

func display_panel(panel_name: String) -> void:
	for panel in %Panels.get_children():
		panel.hide()
		
	match panel_name:
		"MainPanel":
			%MainPanel.show()
		"PracticePanel":
			%PracticePanel.show()
		"InvitePanel":
			%InvitePanel.show()
