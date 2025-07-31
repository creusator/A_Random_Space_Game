extends Node2D
class_name Wing

@export var data:WingData

signal wing_destroyed(wing:Wing)

var mass:int

func _ready() -> void:
	mass = data.mass

func _on_health_component_health_depleted() -> void:
	wing_destroyed.emit(self)
	queue_free()
