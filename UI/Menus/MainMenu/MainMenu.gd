extends Panel

@onready var play_button:Button = $MainMenuButtons/PlayButton
@onready var quit_button:Button = $MainMenuButtons/QuitButton
@onready var version_label:Label = $MainMenuButtons/Version

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	version_label.text = GlobalVariables.version

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
