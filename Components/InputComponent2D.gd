class_name InputComponent2D
extends Node

var target: Vector2
var thrust_vector: Vector2
var rotation_direction: float
var throttle: float = 0.0
var throttle_speed: float = 0.5
var throttle_deadzone: float = 0.1
var precision_mode: bool = false
var _toggle_state: bool = false

func _process(delta: float) -> void:
	var hold_active: bool = Input.is_action_pressed("enable_precision_mode_hold")
	if Input.is_action_just_pressed("enable_precision_mode_toggle"):
		_toggle_state = !_toggle_state
	precision_mode = _toggle_state or hold_active
	if precision_mode or hold_active or Input.is_action_just_pressed("reset_throttle"):
		reset_throttle()
	if not precision_mode:
		if Input.is_action_pressed("thrust_up"):
			throttle += throttle_speed * delta
		elif Input.is_action_pressed("thrust_down"):
			throttle -= throttle_speed * delta
		throttle = clamp(throttle, -1.0, 1.0)

func get_thrust_vector() -> Vector2:
	if precision_mode:
		thrust_vector = Input.get_vector("thrust_left(alt)", "thrust_right(alt)", "thrust_up", "thrust_down")
		return thrust_vector
	else:
		var lateral = Input.get_axis("thrust_left", "thrust_right")
		var effective_throttle = throttle
		if abs(throttle) < throttle_deadzone:
			effective_throttle = 0.0
		thrust_vector = Vector2(lateral, -effective_throttle)
		return thrust_vector

func get_raw_thrust_vector() -> Vector2:
	thrust_vector = Input.get_vector("thrust_left(alt)", "thrust_right(alt)", "thrust_up", "thrust_down")
	return thrust_vector

func get_rotation_dir() -> float:
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")
	if precision_mode:
		return 0.0
	else:
		return rotation_direction

func reset_throttle():
	throttle = 0.0
