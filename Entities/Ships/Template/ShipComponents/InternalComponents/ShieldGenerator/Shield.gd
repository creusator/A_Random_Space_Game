class_name Shield
extends ShipComponent

signal shield_depleted(component:ShipComponent)

@onready var shield:CollisionShape2D = $HurtboxComponent/CollisionShape2D

func _ready() -> void:
	super()

func initialize() -> void:
	health_component.set_health(self.get_parent().shield_health)

func _on_structural_parent_destroyed(_component: ShipComponent):
	component_destroyed.emit(self)
	self.queue_free()

func _on_health_component_health_depleted():
	shield.set_deferred("disabled", true)
	shield_depleted.emit()
	await get_tree().create_timer(get_parent().time_to_reload).timeout
	health_component.set_health(get_parent().shield_health)
	shield.set_deferred("disabled", false)
