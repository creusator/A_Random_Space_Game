class_name Shield
extends ShipComponent

signal shield_depleted(component:ShipComponent)

@onready var vfx: Sprite2D = $VFX
@onready var shield_collision:CollisionShape2D = $HurtboxComponent/CollisionShape2D
@onready var generator = get_parent() as ShieldGenerator

var is_active:bool = true

func _ready() -> void:
	super()

func initialize() -> void:
	health_component.set_health(self.get_parent().shield_health)

func set_active(active:bool) -> void:
	is_active = active
	shield_collision.set_deferred("disabled", not active)

func start_shield_recharge() -> void:
	await get_tree().create_timer(get_parent().time_to_reload).timeout
	if generator.is_operational() and is_active:
		health_component.set_health(generator.shield_health)
		shield_collision.set_deferred("disabled", false)
		vfx.material.set_shader_parameter("color", Vector4(0.0,0.8,1.0,1.0))

func _on_health_component_health_depleted():
	if not is_active:
		return
	shield_collision.set_deferred("disabled", true)
	vfx.material.set_shader_parameter("color", Vector4(0.0,0.0,0.0,0.0))
	shield_depleted.emit()
	start_shield_recharge()
