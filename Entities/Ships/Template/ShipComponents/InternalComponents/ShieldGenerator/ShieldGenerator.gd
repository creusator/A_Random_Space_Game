class_name ShieldGenerator
extends ShipComponent

@export var data:ShieldGeneratorData

var mass:int
var power_consumption:int
var time_to_reload:float

func _ready() -> void:
	super()
	mass = data.mass
	power_consumption = data.power_consumption
	time_to_reload = data.time_to_reload
