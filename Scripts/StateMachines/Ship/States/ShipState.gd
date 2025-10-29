class_name ShipState
extends Node

var state_machine: ShipStateMachine
var ship: Ship

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func get_motion() -> MotionComponent2D:
	return ship.motion_component_2d

func get_input() -> InputComponent2D:
	return ship.input_component_2d

func is_powered() -> bool:
	return ship.is_powered
