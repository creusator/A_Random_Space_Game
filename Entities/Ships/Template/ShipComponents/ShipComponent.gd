extends Node2D
class_name ShipComponent

signal component_destroyed(component:ShipComponent)

@export var structural_parent:ShipComponent
@onready var health_component:HealthComponent = get_node("HealthComponent")

var is_ship_powered:bool = true

func _ready() -> void:
	health_component.health_depleted.connect(_on_health_component_health_depleted)
	if structural_parent != null:
		structural_parent.component_destroyed.connect(_on_structural_parent_destroyed)

func on_ship_power_changed(powered:bool) -> void:
	is_ship_powered = powered
	if powered:
		on_powered()
	else:
		on_unpowered()

func on_powered() -> void:
	pass

func on_unpowered() -> void:
	pass

func is_operational() -> bool:
	return is_ship_powered

func _on_structural_parent_destroyed(_component: ShipComponent):
	component_destroyed.emit(self)
	self.queue_free()

func _on_health_component_health_depleted():
	component_destroyed.emit(self)
	self.queue_free()
