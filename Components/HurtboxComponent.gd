extends Area2D
class_name HurtboxComponent

signal taken_damage(damage:int)

@export var health_component:HealthComponent

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox:HitboxComponent) -> void:
	if hitbox != null:
		health_component.health -= hitbox.damage
		taken_damage.emit(hitbox.damage)
