extends Control

@onready var play_button: Button = $MarginContainer/MainMenuButtons/PlayButton
@onready var settings_button: Button = $MarginContainer/MainMenuButtons/SettingsButton
@onready var quit_button: Button = $MarginContainer/MainMenuButtons/QuitButton
@onready var version_label: Label = $MarginContainer/MainMenuButtons/Version


func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	version_label.text = GlobalVariables.version

func _on_play_button_pressed() -> void:
	GlobalVariables.previous_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_settings_button_pressed() -> void:
	GlobalVariables.previous_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file("res://UI/Menus/SettingsMenu/SettingsMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
