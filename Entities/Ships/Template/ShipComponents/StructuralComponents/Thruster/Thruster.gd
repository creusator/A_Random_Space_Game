class_name Thruster
extends ShipComponent

@export var data:ThrusterData

var mass:int
var main_thrust_power:int
var side_thrust_power:int
var fuel_consumption:int
var power_consumption:int

func _ready() -> void:
	super()
	mass = data.mass
	main_thrust_power = data.main_thrust_power
	side_thrust_power = data.side_thrust_power
	fuel_consumption = data.fuel_consumption
	power_consumption = data.power_consumption
