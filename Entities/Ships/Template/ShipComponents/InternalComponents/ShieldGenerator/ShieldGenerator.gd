class_name ShieldGenerator
extends ShipComponent

@export var data:ShieldGeneratorData

@onready var shield:Shield = $Shield

var mass:int
var power_consumption:int
var shield_health:int
var time_to_reload:float

func _ready() -> void:
	super()
	mass = data.mass
	power_consumption = data.power_consumption
	shield_health = data.shield_health
	time_to_reload = data.time_to_reload
	shield.initialize()

func on_powered() -> void:
	if shield:
		shield.set_active(true)

func on_unpowered() -> void:
	if shield:
		shield.set_active(false)
		shield.vfx.material.set_shader_parameter("color", Vector4(0.0,0.0,0.0,0.0))
