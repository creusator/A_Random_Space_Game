extends Node2D

var mass: float
var side_thrust_power: float
var moment_of_inertia_factor: float = 0.5
var rotation_dampeners_efficiency: float
var max_rotation_speed_deg: float
var max_angular_velocity_rad: float
var angular_velocity_rad: float

var angle_to_target: float

func apply_data(data: ShipData):
	mass = data.mass
	side_thrust_power = data.side_thrust_power
	max_rotation_speed_deg = data.max_rotation_speed
	rotation_dampeners_efficiency = data.rotation_dampeners_efficiency
	max_angular_velocity_rad = deg_to_rad(max_rotation_speed_deg)

func player_rotation(rotation_direction, delta):
	
	var moment_of_inertia = calculate_moment()
	var torque = calculate_torque(rotation_direction)

	if abs(rotation_direction) < 0.01 and rotation_dampeners_efficiency > 0.0:
		var damping_torque = -angular_velocity_rad * (side_thrust_power * rotation_dampeners_efficiency)
		torque += damping_torque

	var angular_acceleration = torque / moment_of_inertia
	angular_velocity_rad += angular_acceleration * delta
	angular_velocity_rad = clamp(angular_velocity_rad, -max_angular_velocity_rad, max_angular_velocity_rad)
	
	if abs(rotation_direction) < 0.01 and abs(angular_velocity_rad) < 0.1:
		angular_velocity_rad = 0.0
	rotation += angular_velocity_rad * delta
	return rotation

func calculate_moment():
	var moment_of_inertia = mass * moment_of_inertia_factor
	return moment_of_inertia

func calculate_torque(rotation_direction):
	var torque = rotation_direction * side_thrust_power
	return torque

func aim_to_target(ship_position, target_position: Vector2, delta):
	target_position = target_position - ship_position
	angle_to_target = wrapf(atan2(target_position.y, target_position.x) + PI/2 - rotation, -PI, PI)

	var moment_of_inertia = calculate_moment()
	var max_angular_acceleration = side_thrust_power / moment_of_inertia
	var stopping_distance = (angular_velocity_rad * angular_velocity_rad) / (2.0 * max_angular_acceleration)
	var target_direction = sign(angle_to_target)

	var torque = 0.0
	if abs(angle_to_target) <= stopping_distance:
		torque = -sign(angular_velocity_rad) * side_thrust_power
	elif sign(angular_velocity_rad) != target_direction and abs(angular_velocity_rad) > 0.1:
		torque = -sign(angular_velocity_rad) * side_thrust_power
	else:
		torque = target_direction * side_thrust_power

	var angular_acceleration = torque / moment_of_inertia
	angular_velocity_rad += angular_acceleration * delta
	angular_velocity_rad = clamp(angular_velocity_rad, -max_angular_velocity_rad, max_angular_velocity_rad)

	if abs(angle_to_target) < 0.1 and abs(angular_velocity_rad) < 0.1:
		angular_velocity_rad = 0.0
	rotation += angular_velocity_rad * delta
	return rotation
