class_name Hyperdrive
extends ShipComponent

@export var data:HyperdriveData

var mass:int
var power_consumption:int

func _ready() -> void:
	super()
	mass = data.mass
	power_consumption = data.power_consumption
