extends Node2D
class_name Chassis

@export var data:ChassisData

signal chassis_destroyed

var mass:int
var max_move_speed:int
var max_rotation_speed:int
var moment_of_inertia_factor:float
var power_consumption:int

func _ready() -> void:
	mass = data.mass
	max_move_speed = data.max_move_speed
	max_rotation_speed = data.max_rotation_speed
	moment_of_inertia_factor = data.moment_of_inertia_factor
	power_consumption = data.power_consumption

func _on_health_component_health_depleted() -> void:
	chassis_destroyed.emit()
