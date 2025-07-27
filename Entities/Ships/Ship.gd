extends CharacterBody2D
class_name Ship

@export var ship_data: ShipData

func _ready():
	if ship_data:
		ship_data.apply_to_ship(self)
