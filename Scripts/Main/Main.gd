extends Node2D

@onready var PauseMenu = $Ship/PauseMenu
@onready var Ship = $Ship
var paused = false

func _process(_delta: float) -> void:
	PauseMenu.rotation = -Ship.rotation
	if Input.is_action_just_pressed("open_pause_menu"):
		pauseMenu()

func pauseMenu():
	if paused :
		PauseMenu.hide()
	else :
		PauseMenu.show()
	paused = !paused
