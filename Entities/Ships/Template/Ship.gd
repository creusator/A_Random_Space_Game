class_name Ship
extends CharacterBody2D

var mass:int
var main_thrust_power:int
var side_thrust_power:int
var max_local_speed:int
var max_travel_speed:int
var max_rotation_speed:int
var fuel_consumption:int
var power_consumption:int
var moment_of_inertia_factor:float

@onready var structural_components: StructuralComponentManager = $StructuralComponentManager
@onready var internal_components: InternalComponentManager = $InternalComponentManager
@onready var motion_component_2d: MotionComponent2D = $MotionComponent2D

func _ready() -> void:
	initialize_ship_data()
	structural_components.chassis_destroyed.connect(_on_chassis_destroyed)
	structural_components.thrusters_destroyed.connect(_on_thrusters_destroyed)
	structural_components.wings_destroyed.connect(_on_wings_destroyed)

func initialize_ship_data():
	mass = structural_components.total_structure_mass + internal_components.total_internal_mass
	main_thrust_power = structural_components.total_main_thrust
	side_thrust_power = structural_components.total_side_thrust
	max_local_speed = structural_components.max_local_speed
	max_travel_speed = structural_components.max_travel_speed
	max_rotation_speed = structural_components.max_rotation_speed
	fuel_consumption = structural_components.total_fuel_consumption + internal_components.total_fuel_consumption
	power_consumption = structural_components.total_power_consumption + internal_components.total_power_consumption
	moment_of_inertia_factor = structural_components.moment_of_inertia_factor
	motion_component_2d.initialize()

func _on_chassis_destroyed():
	self.queue_free()

func _on_thrusters_destroyed():
	initialize_ship_data()

func _on_wings_destroyed():
	initialize_ship_data()
