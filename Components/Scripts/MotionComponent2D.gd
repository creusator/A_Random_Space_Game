extends Node2D
class_name MotionComponent2D

@export var controller:Node2D
@export var controlled:CharacterBody2D

const PIXEL_PER_METER = 10

var mass: float
var main_thrust_power: float
var side_thrust_power: float
var max_move_speed: float
var inertial_dampener_efficiency: float
var moment_of_inertia_factor: float = 0.5
var rotation_dampeners_efficiency: float
var max_rotation_speed_deg: float
var max_angular_velocity_rad: float
var angular_velocity_rad: float

var angle_to_target: float

func _physics_process(delta: float) -> void:
	controlled.velocity = player_movement(controlled.velocity, controller.get_thrust_vector().rotated(controlled.rotation), delta)
	controlled.rotation = player_rotation(controller.get_rotation_dir(), delta)
	controlled.move_and_slide()

func apply_data(data: ShipData):
	mass = data.mass
	main_thrust_power = (data.main_thrust_power) * PIXEL_PER_METER
	side_thrust_power = data.side_thrust_power
	max_move_speed = (data.max_move_speed) * PIXEL_PER_METER
	inertial_dampener_efficiency = data.inertial_dampeners_efficiency
	max_rotation_speed_deg = data.max_rotation_speed
	rotation_dampeners_efficiency = data.rotation_dampeners_efficiency
	max_angular_velocity_rad = deg_to_rad(max_rotation_speed_deg)

func player_movement(velocity: Vector2, thrust_vector: Vector2,delta: float) -> Vector2:
	var thrust_force: Vector2 = calculate_thrust(thrust_vector)
	var dampening_force: Vector2 = Vector2.ZERO
	
	if thrust_vector.length() < 0.1 and inertial_dampener_efficiency >= 0.0:
		dampening_force = calculate_dampening(velocity)
	
	var force_total: Vector2 = thrust_force + dampening_force
	var acceleration: Vector2 = force_total / mass
	var applied_velocity: Vector2 = velocity + acceleration * delta
	
	if thrust_vector.length() < 0.1 and applied_velocity.length() < 10.0:
		applied_velocity = Vector2.ZERO
	elif applied_velocity.length() > max_move_speed:
		applied_velocity = applied_velocity.normalized() * max_move_speed
	return applied_velocity

func calculate_thrust(thrust_vector: Vector2) -> Vector2:
	if thrust_vector.length() > 0.01:
		return thrust_vector.normalized() * main_thrust_power * thrust_vector.length()
	return Vector2.ZERO

func calculate_dampening(velocity: Vector2) -> Vector2:
	if inertial_dampener_efficiency <= 0.0 or velocity.length() < 0.1:
		return Vector2.ZERO
	var dampening_force = -velocity.normalized() * main_thrust_power * inertial_dampener_efficiency
	return dampening_force

func player_rotation(rotation_direction, delta):
	var moment_of_inertia = calculate_moment()
	var torque = calculate_torque(rotation_direction)

	if abs(rotation_direction) < 0.01 and rotation_dampeners_efficiency > 0.0:
		var damping_torque = -angular_velocity_rad * (side_thrust_power * rotation_dampeners_efficiency)
		torque += damping_torque
	
	var angular_acceleration = torque / moment_of_inertia
	angular_velocity_rad += angular_acceleration * delta
	angular_velocity_rad = clamp(angular_velocity_rad, -max_angular_velocity_rad, max_angular_velocity_rad)
	
	if abs(rotation_direction) < 0.01 and abs(angular_velocity_rad) < 0.008:
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
