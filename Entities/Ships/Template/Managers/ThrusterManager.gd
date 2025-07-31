extends Node2D
class_name ThrusterManager

signal thruster_destroyed

var total_thruster_mass:int = 0
var total_main_thrust:int = 0
var total_side_thrust:int = 0
var total_fuel_consumption:int = 0
var total_power_consumption:int = 0

func _ready() -> void:
	for thruster:Thruster in self.get_children():
		total_thruster_mass += thruster.mass
		total_main_thrust += thruster.main_thrust_power
		total_side_thrust += thruster.side_thrust_power
		total_fuel_consumption += thruster.fuel_consumption
		total_power_consumption += thruster.power_consumption
		thruster.thruster_destroyed.connect(_on_thruster_destroyed)

func _on_thruster_destroyed(thruster:Thruster):
	total_thruster_mass -= thruster.mass
	total_main_thrust -= thruster.main_thrust_power
	total_side_thrust -= thruster.side_thrust_power
	total_fuel_consumption -= thruster.fuel_consumption
	total_power_consumption -= thruster.power_consumption
	thruster_destroyed.emit()
