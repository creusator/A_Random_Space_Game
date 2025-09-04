class_name InternalComponentManager
extends Node2D

signal power_plant_destroyed
signal sensor_destroyed
signal life_support_destroyed

var total_internal_mass:int = 0
var total_sensors_range:int = 0
var total_power_generation:int = 0
var total_power_consumption:int = 0
var total_fuel_consumption:float = 0.0
var total_fuel_capacity:float = 0.0

func _ready() -> void:
	initialize_power_plants()
	initialize_sensors()
	initalize_life_supports()
	initialize_fuel_tanks()

func _process(_delta: float) -> void:
	update_internal_data()

func update_internal_data() -> void:
	total_internal_mass = 0
	total_power_generation = 0
	total_fuel_consumption = 0
	total_fuel_capacity = 0
	for power_plant:ShipComponent in self.get_children():
		if power_plant is PowerPlant:
			total_internal_mass += power_plant.mass
			total_power_generation += power_plant.power_generation
			total_fuel_consumption += power_plant.fuel_consumption
	for fuel_tank:ShipComponent in self.get_children():
		if fuel_tank is FuelTank:
			total_internal_mass += fuel_tank.mass
			total_fuel_capacity += fuel_tank.capacity

func initialize_power_plants() -> void:
	for power_plant:ShipComponent in self.get_children():
		if power_plant is PowerPlant:
			total_internal_mass += power_plant.mass
			total_power_generation += power_plant.power_generation
			total_fuel_consumption += power_plant.fuel_consumption
			power_plant.component_destroyed.connect(_on_power_plant_destroyed)

func initialize_sensors() -> void:
	for sensor:ShipComponent in self.get_children():
		if sensor is Sensors:
			total_internal_mass += sensor.mass
			total_sensors_range = max(total_sensors_range, sensor.sensors_range)
			total_power_consumption += sensor.power_consumption
			sensor.component_destroyed.connect(_on_sensor_destroyed)

func initalize_life_supports() -> void:
	for life_support in self.get_children():
		if life_support is LifeSupport:
			total_internal_mass += life_support.mass
			total_power_consumption += life_support.power_consumption
			life_support.component_destroyed.connect(_on_life_support_destroyed)

func initialize_fuel_tanks() -> void:
	for fuel_tank:ShipComponent in self.get_children():
		if fuel_tank is FuelTank:
			total_internal_mass += fuel_tank.mass
			total_fuel_capacity += fuel_tank.capacity

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
