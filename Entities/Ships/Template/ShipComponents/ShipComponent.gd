extends Node2D
class_name ShipComponent

signal component_destroyed(component:ShipComponent)

@export var structural_parent:ShipComponent
@onready var health_component:HealthComponent = get_node("HealthComponent")

func _ready() -> void:
	health_component.health_depleted.connect(_on_health_component_health_depleted)
	if structural_parent != null: 
		structural_parent.component_destroyed.connect(_on_structural_parent_destroyed)

func _on_structural_parent_destroyed():
	health_component.set_health(0)

func _on_health_component_health_depleted():
	component_destroyed.emit(self)
	self.queue_free()
