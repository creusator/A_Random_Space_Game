class_name PlayerInputComponent2D
extends InputComponent2D

var direction_vector:Vector2

func get_direction_vector() -> Vector2 :
	return Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
