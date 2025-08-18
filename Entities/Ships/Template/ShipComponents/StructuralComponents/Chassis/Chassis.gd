class_name Chassis
extends ShipComponent

@export var data:ChassisData

var mass:int
var max_local_speed:int
var max_travel_speed:int
var max_rotation_speed:int
var moment_of_inertia_factor:float
var power_consumption:int

func _ready() -> void:
	super()
	mass = data.mass
	max_local_speed = data.max_local_speed
	max_travel_speed = data.max_travel_speed
	max_rotation_speed = data.max_rotation_speed
	moment_of_inertia_factor = data.moment_of_inertia_factor
	power_consumption = data.power_consumption
