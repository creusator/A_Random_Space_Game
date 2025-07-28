extends Node
class_name HealthComponent

signal max_health_changed(difference:int)
signal health_changed(difference:int)
signal health_depleted

@export var max_health:int = 0 : set = set_max_health, get = get_max_health
@export var immortal:bool = false : set = set_immortal, get = get_immortal

@onready var health:int = max_health : set = set_health, get = get_health

func set_max_health(value:int):
	var clamped_value = 1 if value <= 0 else value
	if not clamped_value == max_health :
		var difference = clamped_value - max_health
		max_health_changed.emit(difference)
		if health > max_health:
			health = max_health
		else : 
			max_health = clamped_value

func get_max_health() -> int:
	return max_health

func set_immortal(value:bool):
	immortal = value

func get_immortal() -> bool:
	return immortal

func set_health(value:int):
	if value < health and immortal:
		return 
	
	var clamped_value = clamp(value, 0, max_health)
	if not clamped_value == health:
		var difference = clamped_value - health
		health = clamped_value
		health_changed.emit(difference)
		
		if health == 0:
			health_depleted.emit()

func get_health() -> int:
	return health
