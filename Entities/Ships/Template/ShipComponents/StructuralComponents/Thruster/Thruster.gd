class_name Thruster
extends ShipComponent

@onready var vfx = $GPUParticles2D
@onready var motion_component_2d: MotionComponent2D = $"../../MotionComponent2D"
@onready var input_component_2d: InputComponent2D = $"../../InputComponent2D"

@export var data:ThrusterData
var vfx_light:PointLight2D
var initial_vfx_scale:Vector2
var initial_vfx_light_energy:float
var mass:int
var main_thrust_power:int
var side_thrust_power:int
var power_consumption:int
var fuel_consumption:float
var current_main_thrust:int = 0
var current_side_thrust:int = 0

func _ready() -> void:
	super()
	if vfx is GPUParticles2D:
		initial_vfx_scale = vfx.scale
		initial_vfx_light_energy = 0.5
		vfx_light = vfx.get_child(0)
	mass = data.mass
	main_thrust_power = data.main_thrust_power
	side_thrust_power = data.side_thrust_power
	fuel_consumption = data.fuel_consumption
	power_consumption = data.power_consumption
	current_main_thrust = main_thrust_power
	current_side_thrust = side_thrust_power

func _process(_delta: float) -> void:
	if vfx is GPUParticles2D and vfx_light is PointLight2D:
		update_vfx()

func on_powered() -> void:
	current_main_thrust = main_thrust_power
	current_side_thrust = side_thrust_power

func on_unpowered() -> void:
	current_main_thrust = 0
	current_side_thrust = 0

func update_vfx() -> void:
	if is_operational() :
		vfx.scale.y = initial_vfx_scale.y * abs(input_component_2d.throttle) * 2
		vfx_light.energy = initial_vfx_light_energy * abs(input_component_2d.throttle) * 2
		if vfx.scale < initial_vfx_scale:
			vfx.scale = initial_vfx_scale
		if vfx_light.energy < initial_vfx_light_energy :
			vfx_light.energy = initial_vfx_light_energy
		
	else :
		vfx.scale = Vector2.ZERO


func get_current_main_thrust() -> int:
	return current_main_thrust

func get_current_side_thrust() -> int:
	return current_side_thrust
