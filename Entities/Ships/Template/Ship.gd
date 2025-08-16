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

@onready var structural_components: StructuralComponentManager = $StructuralComponentManager
@onready var motion_component_2d: MotionComponent2D = $MotionComponent2D

func _ready() -> void:
	initialize_ship_data()
	structural_components.chassis_destroyed.connect(_on_chassis_destroyed)
	structural_components.thruster_destroyed.connect(_on_thruster_destroyed)
	structural_components.wing_destroyed.connect(_on_wing_destroyed)

func initialize_ship_data():
	mass = structural_components.total_ship_mass
	main_thrust_power = structural_components.total_main_thrust
	side_thrust_power = structural_components.total_side_thrust
	max_move_speed = structural_components.max_structural_move_speed
	max_rotation_speed = structural_components.max_structural_rotation_speed
	fuel_consumption = structural_components.total_fuel_consumption
	power_consumption = structural_components.total_power_consumption
	moment_of_inertia_factor = 0.5
	motion_component_2d.initialize()

func _on_chassis_destroyed():
	initialize_ship_data()

func _on_thruster_destroyed():
	initialize_ship_data()

func _on_wing_destroyed():
	initialize_ship_data()
