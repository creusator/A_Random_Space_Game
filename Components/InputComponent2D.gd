class_name InputComponent2D
extends Node

var target: Vector2
var thrust_vector: Vector2
var rotation_direction: float
var throttle: float = 0.0
var throttle_speed: float = 0.5
var throttle_deadzone: float = 0.1
var precision_mode: bool = true
var aim_to_target:bool = false
var _toggle_state: bool = true

func _process(delta: float) -> void:
	aim_to_target = Input.is_action_pressed("aim_to_target_hold")
	if Input.is_action_just_pressed("enable_precision_mode_toggle"):
		_toggle_state = !_toggle_state
	precision_mode = _toggle_state
	if precision_mode or Input.is_action_just_pressed("reset_throttle"):
		reset_throttle()
	if not precision_mode:
		if Input.is_action_pressed("thrust_up"):
			throttle += throttle_speed * delta
		elif Input.is_action_pressed("thrust_down"):
			throttle -= throttle_speed * delta
		throttle = clamp(throttle, -1.0, 1.0)

func get_thrust_vector() -> Vector2:
	if precision_mode:
		thrust_vector = Input.get_vector("thrust_left", "thrust_right", "thrust_up", "thrust_down")
		return thrust_vector
	else:
		var lateral_thrust_vector = Input.get_axis("thrust_left", "thrust_right")
		var effective_throttle = throttle
		if abs(throttle) <= throttle_deadzone:
			effective_throttle = 0.0
		thrust_vector = Vector2(lateral_thrust_vector, -effective_throttle)
		return thrust_vector

func get_raw_thrust_vector() -> Vector2:
	thrust_vector = Input.get_vector("thrust_left", "thrust_right", "thrust_up", "thrust_down")
	return thrust_vector

func get_rotation_dir() -> float:
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	if aim_to_target:
		return 0.0
	else:
		return rotation_direction

func reset_throttle():
	throttle = 0.0
