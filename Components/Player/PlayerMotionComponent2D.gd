class_name PlayerMotionComponent2D
extends MotionComponent2D

@export var controller:PlayerInputComponent2D
@export var controlled:CharacterBody2D

func _process(_delta: float) -> void:
	controlled.velocity = controller.get_direction_vector() * 32
