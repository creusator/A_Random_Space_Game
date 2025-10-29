class_name ShipStateMachine
extends Node

@export var initial_state: ShipState
var current_state: ShipState
var states: Dictionary = {}
var ship: Ship

func _ready() -> void:
	ship = get_parent()
	for child in get_children():
		if child is ShipState:
			states[child.name] = child
			child.state_machine = self
			child.ship = ship
	
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
