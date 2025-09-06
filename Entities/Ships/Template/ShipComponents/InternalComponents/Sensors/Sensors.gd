class_name Sensors
extends ShipComponent

@export var data:SensorsData

var mass:int
var power_consumption:int
var sensors_range:int
var spinning:bool
var spin_speed:float

func _ready() -> void:
	super()
	mass = data.mass
	power_consumption = data.power_consumption
	sensors_range = data.sensors_range
	spinning = data.spinning
	spin_speed = data.spin_speed

func _process(delta: float) -> void:
	if spinning:
		rotation += spin_speed * delta

func on_powered() -> void:
	spinning = true
	sensors_range = data.sensors_range

func on_unpowered() -> void:
	spinning = false
	sensors_range = 0
