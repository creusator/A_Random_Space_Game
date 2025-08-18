class_name InputComponent2D
extends Node

var target: Vector2
var thrust_vector: Vector2
var rotation_direction : float
var precision_mode: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_pressed("enable_precision_mode_hold"):
		precision_mode = true
	else :
		precision_mode = false
	if Input.is_action_just_pressed("enable_precision_mode_toggle"):
		precision_mode = !precision_mode

func get_thrust_vector() -> Vector2 :
	thrust_vector = Input.get_vector("thrust_left", "thrust_right", "thrust_up", "thrust_down")
	if precision_mode == true :
		return thrust_vector
	else :
		return Vector2(0.0, thrust_vector.y)

func get_rotation_dir() -> float :
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	if precision_mode == true :
		return 0.0
	else :
		return rotation_direction
