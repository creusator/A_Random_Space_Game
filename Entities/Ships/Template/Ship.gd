extends CharacterBody2D
class_name Ship

var mass:int
var main_thrust_power:int
var side_thrust_power:int
var max_move_speed:int
var max_rotation_speed:int
var fuel_consumption:int
var power_consumption:int
var moment_of_inertia_factor:float

@onready var chassis: Chassis = $Chassis
@onready var thrusters: ThrusterManager = $Thrusters
@onready var motion_component_2d: MotionComponent2D = $MotionComponent2D

func _ready() -> void:
	mass = chassis.mass + thrusters.total_thruster_mass
	main_thrust_power = thrusters.total_main_thrust
	side_thrust_power = thrusters.total_side_thrust
	max_move_speed = chassis.max_move_speed
	max_rotation_speed = chassis.max_rotation_speed
	fuel_consumption = thrusters.total_fuel_consumption
	power_consumption = chassis.power_consumption + thrusters.total_fuel_consumption
	moment_of_inertia_factor = chassis.moment_of_inertia_factor
	motion_component_2d.initialize()
