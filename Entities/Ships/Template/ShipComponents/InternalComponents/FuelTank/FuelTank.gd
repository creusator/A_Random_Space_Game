class_name FuelTank
extends ShipComponent

@export var data:FuelTankData

@onready var timer:Timer = $Timer
@onready var ship:Ship = self.get_parent().get_parent()

var mass:int
var capacity:float
var max_capacity:float

func _ready() -> void:
	super()
	mass = data.mass
	max_capacity = data.max_capacity
	if data.capacity < data.max_capacity:
		capacity = data.capacity
	else :
		capacity = max_capacity
	timer.timeout.connect(_on_fuel_tick)

func _on_fuel_tick():
	capacity -= ship.fuel_consumption
