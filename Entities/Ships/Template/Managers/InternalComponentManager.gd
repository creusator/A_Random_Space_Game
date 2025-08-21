class_name InternalComponentManager
extends Node2D

signal power_plant_destroyed

var total_internal_mass:int = 0
var total_power_generation:int = 0
var total_fuel_consumption:int = 0
var total_power_consumption:int = 0

func _ready() -> void:
	initialize_power_plants()

func initialize_power_plants() -> void:
	for power_plant:ShipComponent in self.get_children():
		if power_plant is PowerPlant:
			total_internal_mass += power_plant.mass
			total_power_generation += power_plant.power_generation
			total_fuel_consumption += power_plant.fuel_consumption
			power_plant.component_destroyed.connect(_on_power_plant_destroyed)

func _on_power_plant_destroyed(power_plant:PowerPlant) -> void:
	total_internal_mass -= power_plant.mass
	total_power_generation -= power_plant.power_generation
	total_fuel_consumption -= power_plant.fuel_consumption
	power_plant_destroyed.emit()
