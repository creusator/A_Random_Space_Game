class_name InternalComponentManager
extends Node2D

signal power_plant_destroyed
signal sensor_destroyed
signal life_support_destroyed
signal shield_generator_destroyed
signal hyperdrive_destroyed

var total_internal_mass:int = 0
var total_sensors_range:int = 0
var total_power_generation:int = 0
var total_power_consumption:int = 0
var total_fuel_consumption:float = 0.0
var total_fuel_capacity:float = 0.0

func _ready() -> void:
	initialize_internal_components()

func _process(_delta: float) -> void:
	update_internal_data()

func update_internal_data() -> void:
	total_internal_mass = 0
	total_power_generation = 0
	total_fuel_consumption = 0
	total_fuel_capacity = 0
	for component:ShipComponent in self.get_children():
		if component is PowerPlant:
			total_internal_mass += component.mass
			total_power_generation += component.power_generation
			total_fuel_consumption += component.fuel_consumption
		elif component is FuelTank:
			total_internal_mass += component.mass
			total_fuel_capacity += component.capacity

func initialize_internal_components() -> void:
	for component:ShipComponent in self.get_children():
		if component is PowerPlant:
			total_internal_mass += component.mass
			total_power_generation += component.power_generation
			total_fuel_consumption += component.fuel_consumption
			component.component_destroyed.connect(_on_power_plant_destroyed)
		elif component is Sensors:
			total_internal_mass += component.mass
			total_sensors_range = max(total_sensors_range, component.sensors_range)
			total_power_consumption += component.power_consumption
			component.component_destroyed.connect(_on_sensor_destroyed)
		elif component is LifeSupport:
			total_internal_mass += component.mass
			total_power_consumption += component.power_consumption
			component.component_destroyed.connect(_on_life_support_destroyed)
		elif component is ShieldGenerator:
			total_internal_mass += component.mass
			total_power_consumption += component.power_consumption
			component.component_destroyed.connect(_on_shield_generator_destroyed)
		elif component is Hyperdrive:
			total_internal_mass += component.mass
			total_power_consumption += component.power_consumption
			component.component_destroyed.connect(_on_hyperdrive_destroyed)
		elif component is FuelTank:
			total_internal_mass += component.mass
			total_fuel_capacity += component.capacity
		else :
			printerr('Unhandled components detected')
			return

func _on_power_plant_destroyed(power_plant:PowerPlant) -> void:
	total_internal_mass -= power_plant.mass
	total_power_generation -= power_plant.power_generation
	total_fuel_consumption -= power_plant.fuel_consumption
	power_plant_destroyed.emit()

func _on_sensor_destroyed(sensor:Sensors) -> void:
	total_internal_mass -= sensor.mass
	total_power_consumption -= sensor.power_consumption
	sensor_destroyed.emit()

func _on_life_support_destroyed(life_support:LifeSupport) -> void:
	total_internal_mass -= life_support.mass
	total_power_consumption -= life_support.power_consumption
	life_support_destroyed.emit()

func _on_shield_generator_destroyed(shield_generator:ShieldGenerator) -> void:
	total_internal_mass -= shield_generator.mass
	total_power_consumption -= shield_generator.power_consumption
	shield_generator_destroyed.emit()

func _on_hyperdrive_destroyed(hyperdrive:Hyperdrive) -> void:
	total_internal_mass -= hyperdrive.mass
	total_power_consumption -= hyperdrive.power_consumption
	hyperdrive_destroyed.emit()
