extends CharacterBody2D
class_name Ship

@export var ship_data: ShipData

func _ready():
	if ship_data:
		ship_data.apply_to_ship(self)

func _on_health_component_health_depleted() -> void:
	queue_free()
