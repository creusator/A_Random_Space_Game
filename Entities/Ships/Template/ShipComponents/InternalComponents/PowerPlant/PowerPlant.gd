class_name PowerPlant
extends ShipComponent

@export var data:PowerPlantData
@onready var sprite:Sprite2D = get_node("Sprite2D")

var mass:int
var power_generation:int
var fuel_consumption:float

func _ready() -> void:
	super()
	mass = data.mass
	power_generation = data.power_generation
	fuel_consumption = data.fuel_consumption

func on_powered() -> void:
	sprite.material.set_shader_parameter("is_active", true)

func on_unpowered() -> void:
	sprite.material.set_shader_parameter("is_active", false)
