extends Node2D
class_name Thruster

@export var data:ThrusterData

signal thruster_destroyed(thruster:Thruster)

var mass:int
var main_thrust_power:int
var side_thrust_power:int
var fuel_consumption:int
var power_consumption:int

func _ready() -> void:
	mass = data.mass
	main_thrust_power = data.main_thrust_power
	side_thrust_power = data.side_thrust_power
	fuel_consumption = data.fuel_consumption
	power_consumption = data.power_consumption

func _on_health_component_health_depleted() -> void:
	thruster_destroyed.emit(self)
	queue_free()
