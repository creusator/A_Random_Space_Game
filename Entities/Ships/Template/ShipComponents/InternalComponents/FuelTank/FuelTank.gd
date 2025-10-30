class_name FuelTank
extends ShipComponent

@export var data:FuelTankData

@onready var ship:Ship = self.get_parent().get_parent()

var mass:int
var capacity:float
var max_capacity:float

func _ready() -> void:
	super()
	mass = data.mass
	max_capacity = data.max_capacity
	capacity = max_capacity
	capacity = clamp(capacity, 0.0, max_capacity)

func _on_timer_timeout() -> void:
	capacity = clamp(capacity - ship.fuel_consumption, 0.0, max_capacity)
