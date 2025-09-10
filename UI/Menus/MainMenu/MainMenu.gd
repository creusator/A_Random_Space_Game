extends Panel

@onready var play_button:Button = $MainMenuButtons/PlayButton

func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")
