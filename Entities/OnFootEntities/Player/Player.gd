class_name Player
extends CharacterBody2D

@onready var player_motion_component_2d: PlayerMotionComponent2D = $PlayerMotionComponent2D
@onready var player_input_component_2d: PlayerInputComponent2D = $PlayerInputComponent2D

var sitting: bool = false
