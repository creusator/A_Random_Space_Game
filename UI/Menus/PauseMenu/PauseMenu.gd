extends Control

@onready var resume_button:Button = $Panel/PauseMenuButtons/ResumeButton
@onready var restart_button:Button = $Panel/PauseMenuButtons/RestartButton
@onready var settings_button:Button = $Panel/PauseMenuButtons/SettingsButton
@onready var main_menu_button:Button = $Panel/PauseMenuButtons/MainMenuButton
@onready var quit_button:Button = $Panel/PauseMenuButtons/QuitButton
@onready var animation_player = $AnimationPlayer

var is_paused:bool = false

func _ready() -> void:
	hide()
	resume_button.pressed.connect(_on_resume_button_pressed)
	restart_button.pressed.connect(_on_restart_button_pressed)
	settings_button.pressed.connect(_on_settings_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	animation_player.play("RESET")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_pause_menu"):
		toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	get_tree().paused = is_paused
	if is_paused:
		show()
		animation_player.play("PauseMenuBlurAnimation")
	else: 
		animation_player.play_backwards("PauseMenuBlurAnimation")
		await animation_player.animation_finished
		hide()

func _on_resume_button_pressed() -> void:
	toggle_pause()

func _on_restart_button_pressed() -> void:
	toggle_pause()
	get_tree().reload_current_scene()

func _on_settings_button_pressed() -> void:
	pass

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/Menus/MainMenu/MainMenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
