class_name StructuralComponentManager
extends Node2D

signal chassis_destroyed
signal thrusters_destroyed
signal wings_destroyed

var max_local_speed:int = 0
var max_travel_speed:int = 0
var max_rotation_speed:int = 0
var moment_of_inertia_factor:float = 0.0
var total_structure_mass:int = 0
var total_chassis_mass:int = 0
var total_thruster_mass:int = 0
var total_wing_mass:int = 0
var total_main_thrust:int = 0
var total_side_thrust:int = 0
var total_fuel_consumption:int = 0
var total_power_consumption:int = 0

func _ready() -> void:
	initialize_chassis_data()
	initialize_thruster_data()
	initialize_wing_data()
	total_structure_mass = total_chassis_mass + total_thruster_mass + total_wing_mass

func initialize_chassis_data() -> void:
	for chassis:ShipComponent in self.get_children():
		if chassis is Chassis:
			total_chassis_mass += chassis.mass
			max_local_speed = chassis.max_local_speed
			max_travel_speed = chassis.max_travel_speed
			max_rotation_speed = chassis.max_rotation_speed
			moment_of_inertia_factor = chassis.moment_of_inertia_factor
			total_power_consumption += chassis.power_consumption
			chassis.component_destroyed.connect(_on_chassis_destroyed)

func initialize_thruster_data() -> void:
	for thruster:ShipComponent in self.get_children():
		if thruster is Thruster:
			total_thruster_mass += thruster.mass
			total_main_thrust += thruster.main_thrust_power
			total_side_thrust += thruster.side_thrust_power
			total_fuel_consumption += thruster.fuel_consumption
			total_power_consumption += thruster.power_consumption
			thruster.component_destroyed.connect(_on_thruster_destroyed)

func initialize_wing_data() -> void:
	for wing:ShipComponent in self.get_children():
		if wing is Wing:
			total_wing_mass += wing.mass
			wing.component_destroyed.connect(_on_wing_destroyed)

func _on_chassis_destroyed(chassis:Chassis) -> void:
	total_chassis_mass -= chassis.mass
	total_power_consumption -= chassis.power_consumption
	chassis_destroyed.emit()

func _on_thruster_destroyed(thruster:Thruster):
	total_thruster_mass -= thruster.mass
	total_main_thrust -= thruster.main_thrust_power
	total_side_thrust -= thruster.side_thrust_power
	total_fuel_consumption -= thruster.fuel_consumption
	total_power_consumption -= thruster.power_consumption
	thrusters_destroyed.emit()

func _on_wing_destroyed(wing:Wing):
	total_wing_mass -= wing.mass
	wings_destroyed.emit()
