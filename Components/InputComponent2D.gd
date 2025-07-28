extends Node
class_name InputComponent2D

var target: Vector2
var thrust_vector: Vector2
var rotation_direction : float

func get_thrust_vector() -> Vector2 :
	thrust_vector = Input.get_vector("thrust_left", "thrust_right", "thrust_up", "thrust_down")
	return thrust_vector

func get_rotation_dir() -> float :
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	return rotation_direction
