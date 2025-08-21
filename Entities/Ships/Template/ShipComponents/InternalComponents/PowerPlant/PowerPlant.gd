class_name PowerPlant
extends ShipComponent

@export var data:PowerPlantData

var mass:int
var power_generation:int
var fuel_consumption:int

func _ready() -> void:
	super()
	mass = data.mass
	power_generation = data.power_generation
	fuel_consumption = data.fuel_consumption
