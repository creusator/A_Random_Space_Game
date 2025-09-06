class_name Thruster
extends ShipComponent

@export var data:ThrusterData

var mass:int
var main_thrust_power:int
var side_thrust_power:int
var power_consumption:int
var fuel_consumption:float
var current_main_thrust:int = 0
var current_side_thrust:int = 0

func _ready() -> void:
	super()
	mass = data.mass
	main_thrust_power = data.main_thrust_power
	side_thrust_power = data.side_thrust_power
	fuel_consumption = data.fuel_consumption
	power_consumption = data.power_consumption
	current_main_thrust = main_thrust_power
	current_side_thrust = side_thrust_power

func on_powered() -> void:
	current_main_thrust = main_thrust_power
	current_side_thrust = side_thrust_power

func on_unpowered() -> void:
	current_main_thrust = 0
	current_side_thrust = 0

func get_current_main_thrust() -> int:
	return current_main_thrust

func get_current_side_thrust() -> int:
	return current_side_thrust
