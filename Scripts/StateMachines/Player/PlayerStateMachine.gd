class_name PlayerStateMachine
extends Node

@export var initial_state: PlayerState
var current_state: PlayerState
var states: Dictionary = {}
var player: Player

func _ready() -> void:
	player = get_parent()
	for child in get_children():
		if child is PlayerState:
			states[child.name] = child
			child.state_machine = self
			child.player = player
	
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func transition_to(state_name: String) -> void:
	if not states.has(state_name):
		push_error("State " + state_name + " does not exist!")
		return
	
	var new_state = states[state_name]
	if current_state == new_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

func get_current_state_name() -> String:
	if current_state:
		return current_state.name
	return ""
