class_name Wing
extends ShipComponent

@export var data:WingData

var mass:int

func _ready() -> void:
	super()
	mass = data.mass
