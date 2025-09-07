class_name StructuralComponentManager
extends Node2D

signal chassis_destroyed
signal thrusters_destroyed
signal wings_destroyed

var max_local_speed:int = 0
var max_travel_speed:int = 0
var max_rotation_speed:int = 0
var moment_of_inertia_factor:float = 0.0
var total_structural_mass:int = 0
var total_main_thrust:int = 0
var total_side_thrust:int = 0
var total_power_consumption:int = 0
var total_fuel_consumption:float = 0.0

func _ready() -> void:
	initialize_structural_data()

func initialize_structural_data() -> void:
	for component:ShipComponent in self.get_children():
		if component is Chassis:
			total_structural_mass += component.mass
			max_local_speed = component.max_local_speed
			max_travel_speed = component.max_travel_speed
			max_rotation_speed = component.max_rotation_speed
			moment_of_inertia_factor = component.moment_of_inertia_factor
			total_power_consumption += component.power_consumption
			component.component_destroyed.connect(_on_chassis_destroyed)
		if component is Thruster:
			total_structural_mass += component.mass
			total_main_thrust += component.main_thrust_power
			total_side_thrust += component.side_thrust_power
			total_fuel_consumption += component.fuel_consumption
			total_power_consumption += component.power_consumption
			component.component_destroyed.connect(_on_thruster_destroyed)
		if component is Wing:
			total_structural_mass += component.mass
			component.component_destroyed.connect(_on_wing_destroyed)

func update_thrust_values() -> void:
	total_main_thrust = 0
	total_side_thrust = 0
	for thruster in get_children():
		if thruster is Thruster:
			total_main_thrust += thruster.get_current_main_thrust()
			total_side_thrust += thruster.get_current_side_thrust()

func _on_chassis_destroyed(chassis:Chassis) -> void:
	total_structural_mass -= chassis.mass
	total_power_consumption -= chassis.power_consumption
	chassis_destroyed.emit()

func _on_thruster_destroyed(thruster:Thruster):
	total_structural_mass -= thruster.mass
	total_main_thrust -= thruster.main_thrust_power
	total_side_thrust -= thruster.side_thrust_power
	total_fuel_consumption -= thruster.fuel_consumption
	total_power_consumption -= thruster.power_consumption
	thrusters_destroyed.emit()

func _on_wing_destroyed(wing:Wing):
	total_structural_mass -= wing.mass
	wings_destroyed.emit()
