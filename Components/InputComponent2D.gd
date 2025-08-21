class_name InputComponent2D
extends Node

var target: Vector2
var thrust_vector: Vector2
var rotation_direction : float
var precision_mode: bool = false
var _toggle_state: bool = false

func _process(_delta: float) -> void:
	var hold_active: bool = Input.is_action_pressed("enable_precision_mode_hold")
	if Input.is_action_just_pressed("enable_precision_mode_toggle"):
		_toggle_state = !_toggle_state
	precision_mode = _toggle_state or hold_active

func get_thrust_vector() -> Vector2 :
	if precision_mode == true :
		thrust_vector = Input.get_vector("thrust_left(alt)", "thrust_right(alt)", "thrust_up", "thrust_down")
		return thrust_vector
	else :
		thrust_vector = Input.get_vector("thrust_left", "thrust_right", "thrust_up", "thrust_down")
		return thrust_vector

func get_rotation_dir() -> float :
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	if precision_mode == true :
		return 0.0
	else :
		return rotation_direction
