class_name Ship
extends CharacterBody2D

var mass:int
var main_thrust_power:int
var side_thrust_power:int
var max_local_speed:int
var max_travel_speed:int
var max_rotation_speed:int
var power_consumption:int
var power_generation:int
var fuel_consumption:float
var fuel_current_capacity:float
var moment_of_inertia_factor:float

var is_powered:bool = false

@onready var structural_components: StructuralComponentManager = $StructuralComponentManager
@onready var internal_components: InternalComponentManager = $InternalComponentManager
@onready var motion_component_2d: MotionComponent2D = $MotionComponent2D
@onready var input_component_2d: InputComponent2D = $InputComponent2D

func _ready() -> void:
	update_ship_data()
	structural_components.chassis_destroyed.connect(_on_chassis_destroyed)
	structural_components.thrusters_destroyed.connect(_on_thrusters_destroyed)
	structural_components.wings_destroyed.connect(_on_wings_destroyed)
	internal_components.power_plant_destroyed.connect(_on_power_plant_destroyed)
	internal_components.sensor_destroyed.connect(_on_sensor_destroyed)
	internal_components.life_support_destroyed.connect(_on_life_support_destroyed)
	internal_components.shield_generator_destroyed.connect(_on_shield_generator_destroyed)
	internal_components.hyperdrive_destroyed.connect(_on_hyperdrive_destroyed)
	
func _process(_delta: float) -> void:
	update_ship_data()

func update_ship_data() -> void:
	var previous_powered = is_powered
	is_powered = (power_generation >= power_consumption) and (fuel_current_capacity > 0.0)
	if previous_powered != is_powered:
		notify_power_state_changed()
	mass = structural_components.total_structural_mass + internal_components.total_internal_mass
	max_local_speed = structural_components.max_local_speed
	max_travel_speed = structural_components.max_travel_speed
	max_rotation_speed = structural_components.max_rotation_speed
	fuel_consumption = structural_components.total_fuel_consumption + internal_components.total_fuel_consumption
	fuel_current_capacity = internal_components.total_fuel_capacity
	power_consumption = structural_components.total_power_consumption + internal_components.total_power_consumption
	power_generation = internal_components.total_power_generation
	moment_of_inertia_factor = structural_components.moment_of_inertia_factor
	structural_components.update_thrust_values()
	main_thrust_power = structural_components.total_main_thrust
	side_thrust_power = structural_components.total_side_thrust
	motion_component_2d.initialize()

func notify_power_state_changed() -> void:
	for component in structural_components.get_children():
		if component.has_method("on_ship_power_changed"):
			component.on_ship_power_changed(is_powered)

	for component in internal_components.get_children():
		if component.has_method("on_ship_power_changed"):
			component.on_ship_power_changed(is_powered)

func get_power_state() -> bool:
	return is_powered

func get_throttle_state() -> float:
	return input_component_2d.get_throttle_state()

func get_precision_state() -> bool:
	return input_component_2d.precision_mode

var smoothed_speed := 0.0
func get_velocity_value() -> int:
	var real_speed = velocity.length() / 10.0
	smoothed_speed = lerp(smoothed_speed, real_speed, 0.1)
	return int(round(smoothed_speed))

func _on_chassis_destroyed() -> void:
	self.queue_free()

func _on_thrusters_destroyed() -> void:
	pass

func _on_wings_destroyed() -> void:
	pass

func _on_power_plant_destroyed() -> void:
	pass

func _on_sensor_destroyed() -> void:
	pass

func _on_life_support_destroyed() -> void:
	pass

func _on_shield_generator_destroyed() -> void:
	pass

func _on_hyperdrive_destroyed() -> void:
	pass
