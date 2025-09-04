class_name LifeSupport
extends ShipComponent

@export var data:LifeSupportData

@onready var timer:Timer = $Timer

var mass:int
var power_consumption:int
var time_to_death:float

func _ready() -> void:
	super()
	mass = data.mass
	power_consumption = data.power_consumption
	time_to_death = data.time_to_death
