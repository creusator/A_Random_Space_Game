class_name Hyperdrive
extends ShipComponent

@export var data:HyperdriveData
@onready var sprite:Sprite2D = get_node("Sprite2D")

var mass:int
var power_consumption:int

func _ready() -> void:
	super()
	mass = data.mass
	power_consumption = data.power_consumption

func on_powered() -> void:
	sprite.material.set_shader_parameter("is_active", true)

func on_unpowered() -> void:
	sprite.material.set_shader_parameter("is_active", false)
