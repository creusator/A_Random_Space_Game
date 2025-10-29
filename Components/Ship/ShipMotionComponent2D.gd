class_name ShipMotionComponent2D
extends MotionComponent2D

@export var controlled:Ship

const PIXEL_PER_METER = GlobalVariables.PIXEL_PER_METER

var mass: float
var main_thrust_power: float
var side_thrust_power: float
var max_local_speed: int
var max_travel_speed: int
var max_rotation_speed: int
var inertial_dampener_efficiency: float = 1.0
var rotation_dampeners_efficiency: float = 1.0
var moment_of_inertia_factor: float
var angular_velocity_rad: float
var current_applied_velocity: Vector2 = Vector2.ZERO

func initialize() -> void:
	mass = controlled.mass
	main_thrust_power = controlled.main_thrust_power
	side_thrust_power = controlled.side_thrust_power
	max_local_speed = controlled.max_local_speed * PIXEL_PER_METER
	max_travel_speed = controlled.max_travel_speed * PIXEL_PER_METER
	max_rotation_speed = int(deg_to_rad(controlled.max_rotation_speed))
	moment_of_inertia_factor = controlled.moment_of_inertia_factor

func ship_movement_throttle(velocity: Vector2, thrust_input: Vector2, current_rotation: float, delta: float) -> Vector2:
	var thrust_direction = Vector2(thrust_input.x, thrust_input.y).rotated(current_rotation)
	var thrust_magnitude = thrust_input.length()
	
	var thrust_force = Vector2.ZERO
	if thrust_magnitude > 0.01:
		thrust_force = thrust_direction.normalized() * main_thrust_power * thrust_magnitude
	
	var force_total = thrust_force * PIXEL_PER_METER
	var acceleration = force_total / mass
	var applied_velocity = velocity + acceleration * delta
	
	if applied_velocity.length() > max_local_speed:
		applied_velocity = applied_velocity.normalized() * max_local_speed
	
	current_applied_velocity = applied_velocity.normalized() if applied_velocity.length() > 0.01 else Vector2.ZERO
	return applied_velocity

func ship_movement_precision(velocity: Vector2, thrust_vector: Vector2, delta: float) -> Vector2:
	var thrust_force: Vector2 = calculate_thrust(thrust_vector)
	var force_total: Vector2 = thrust_force * PIXEL_PER_METER
	var acceleration: Vector2 = force_total / mass
	var applied_velocity: Vector2 = velocity + acceleration * delta
	
	if applied_velocity.length() > max_local_speed:
		applied_velocity = applied_velocity.normalized() * max_local_speed
	
	current_applied_velocity = applied_velocity.normalized() if applied_velocity.length() > 0.01 else Vector2.ZERO
	return applied_velocity

func ship_movement_damp(velocity: Vector2, delta: float) -> Vector2:
	if velocity.length() < 3.5:
		return Vector2.ZERO
	
	var dampening_force = -velocity.normalized() * main_thrust_power * inertial_dampener_efficiency
	var force_total = dampening_force * PIXEL_PER_METER
	var acceleration = force_total / mass
	var applied_velocity = velocity + acceleration * delta
	
	if velocity.dot(applied_velocity) < 0:
		applied_velocity = Vector2.ZERO
	
	current_applied_velocity = applied_velocity.normalized() if applied_velocity.length() > 0.01 else Vector2.ZERO
	return applied_velocity

func calculate_thrust(thrust_vector: Vector2) -> Vector2:
	if thrust_vector.length() > 0.01:
		return thrust_vector.normalized() * main_thrust_power * thrust_vector.length()
	return Vector2.ZERO

func ship_rotation(rotation_direction: float, delta: float) -> float:
	var current_rotation = controlled.rotation
	var moment_of_inertia = calculate_moment()
	var torque = calculate_torque(rotation_direction)
	
	var angular_acceleration = torque / moment_of_inertia
	angular_velocity_rad += angular_acceleration * delta
	angular_velocity_rad = clamp(angular_velocity_rad, -max_rotation_speed, max_rotation_speed)
	
	var new_rotation = current_rotation + angular_velocity_rad * delta
	return new_rotation

func ship_rotation_damp(delta: float) -> float:
	if abs(angular_velocity_rad) < 0.008:
		angular_velocity_rad = 0.0
		return controlled.rotation
	
	var current_rotation = controlled.rotation
	var moment_of_inertia = calculate_moment()
	var damping_torque = -sign(angular_velocity_rad) * side_thrust_power * rotation_dampeners_efficiency
	
	var angular_acceleration = damping_torque / moment_of_inertia
	angular_velocity_rad += angular_acceleration * delta
	if abs(angular_velocity_rad) < 0.008:
		angular_velocity_rad = 0.0
	
	var new_rotation = current_rotation + angular_velocity_rad * delta
	return new_rotation

func calculate_moment() -> float:
	return mass * moment_of_inertia_factor

func calculate_torque(rotation_direction: float) -> float:
	return rotation_direction * side_thrust_power

func aim_to_target(ship_position: Vector2, target_position: Vector2, delta: float) -> float:
	var current_rotation = controlled.rotation
	var target_vector = target_position - ship_position
	var angle_to_target = wrapf(atan2(target_vector.y, target_vector.x) + PI/2 - current_rotation, -PI, PI)
	
	var moment_of_inertia = calculate_moment()
	var max_angular_acceleration = side_thrust_power / moment_of_inertia
	var stopping_distance = (angular_velocity_rad * angular_velocity_rad) / (2.0 * max_angular_acceleration)
	var target_direction = sign(angle_to_target)
	
	var torque = 0.0
	if abs(angle_to_target) <= stopping_distance:
		torque = -sign(angular_velocity_rad) * side_thrust_power
	elif sign(angular_velocity_rad) != target_direction and abs(angular_velocity_rad) > 0.05:
		torque = -sign(angular_velocity_rad) * side_thrust_power
	else:
		torque = target_direction * side_thrust_power
	
	var angular_acceleration = torque / moment_of_inertia
	angular_velocity_rad += angular_acceleration * delta
	angular_velocity_rad = clamp(angular_velocity_rad, -max_rotation_speed, max_rotation_speed)
	 
	if abs(angle_to_target) < 0.05 and abs(angular_velocity_rad) < 0.05:
		angular_velocity_rad = 0.0
	
	var new_rotation = current_rotation + angular_velocity_rad * delta
	return new_rotation
