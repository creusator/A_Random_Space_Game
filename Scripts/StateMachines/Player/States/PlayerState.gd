class_name PlayerState
extends Node

var state_machine: PlayerStateMachine
var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func get_motion() -> MotionComponent2D:
	return player.motion_component_2d

func get_input() -> InputComponent2D:
	return player.input_component_2d
