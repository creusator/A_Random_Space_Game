extends Node2D

var mass: float
var main_thrust_power: float
var max_move_speed: float
var inertial_dampener_efficiency: float

func apply_data(data: ShipData):
	mass = data.mass
	main_thrust_power = data.main_thrust_power
	max_move_speed = data.max_move_speed
	inertial_dampener_efficiency = data.inertial_dampeners_efficiency

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
