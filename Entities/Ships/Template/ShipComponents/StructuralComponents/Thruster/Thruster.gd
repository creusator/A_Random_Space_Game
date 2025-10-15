class_name Thruster
extends ShipComponent

@onready var vfx: GPUParticles2D = $GPUParticles2D
@onready var motion_component_2d: MotionComponent2D = $"../../MotionComponent2D"
@onready var input_component_2d: InputComponent2D = $"../../InputComponent2D"

@export var data:ThrusterData

# Stats
var mass:int
var main_thrust_power:int
var side_thrust_power:int
var power_consumption:int
var fuel_consumption:float
var current_main_thrust:int = 0
var current_side_thrust:int = 0

# VFX - Technicals
var thruster_orientation:Vector2 = Vector2.UP
var raw_thrust_vector:Vector2 = Vector2.ZERO
var current_applied_velocity:Vector2 = Vector2.ZERO
var random = RandomNumberGenerator.new()
var vfx_light:PointLight2D
var initial_vfx_scale:Vector2 = Vector2.ONE

# VFX - Visuals
var target_vfx_scale: float = 1.0
var target_vfx_energy: float = 0.4
var vfx_transition_speed: float = 6.0
var random_light_timer: float = 0.0
var initial_vfx_light_energy:float = 0.5
var vfx_scale_factor:float = 1.0
var vfx_random_light_level:float = 0.0

func _ready() -> void:
	super()
	random.randomize()
	if vfx:
		initial_vfx_scale = vfx.scale
		if vfx.get_child_count() > 0 and vfx.get_child(0) is PointLight2D:
			vfx_light = vfx.get_child(0)
		else:
			vfx_light = null
	if data:
		vfx_scale_factor = data.vfx_scale_factor
		initial_vfx_light_energy = 0.5
		mass = data.mass
		main_thrust_power = data.main_thrust_power
		side_thrust_power = data.side_thrust_power
		fuel_consumption = data.fuel_consumption
		power_consumption = data.power_consumption
		current_main_thrust = main_thrust_power
		current_side_thrust = side_thrust_power
	
	thruster_orientation = Vector2.UP.rotated(rotation).normalized()
	target_vfx_scale = initial_vfx_scale.y
	target_vfx_energy = initial_vfx_light_energy
	random_light_timer = random.randf_range(0.5, 3.0)
	vfx_random_light_level = 0.0

func _process(delta: float) -> void:
	current_applied_velocity = motion_component_2d.current_applied_velocity if motion_component_2d else Vector2.ZERO
	random_light_timer -= delta
	
	if random_light_timer <= 0.0:
		random_light_timer = random.randf_range(0.5, 3.0)
		vfx_random_light_level = random.randf_range(0.0, 0.4)
	if vfx:
		update_vfx(delta)

func update_vfx(delta: float) -> void:
	if not is_operational():
		vfx.scale = initial_vfx_scale
		if vfx_light:
			vfx_light.energy = 0.0
		return
	
	var ship_rotation = motion_component_2d.controlled.rotation
	var thrust_force_direction_world = thruster_orientation.rotated(ship_rotation).normalized()
	var thrust_input_local = input_component_2d.get_thrust_vector()
	var thrust_input_world = thrust_input_local.rotated(ship_rotation)
	var intensity_input := 0.0
	
	if thrust_input_world.length() > 0.01:
		var input_dir_world = thrust_input_world.normalized()
		var dot_in = thrust_force_direction_world.dot(input_dir_world)
		if dot_in > 0.1:
			intensity_input = clamp(dot_in * thrust_input_world.length(), 0.0, 1.0)
	
	var intensity_brake := 0.0
	var ship_velocity = motion_component_2d.controlled.velocity
	var speed = ship_velocity.length()
	var braking_intent := false
	
	if thrust_input_world.length() < 0.05 and speed > 1.0:
		braking_intent = true
	elif thrust_input_world.length() > 0.1:
		var dot_velocity = ship_velocity.normalized().dot(thrust_input_world.normalized())
		if dot_velocity < -0.25:
			braking_intent = true
	
	if braking_intent and motion_component_2d.inertial_dampener_efficiency > 0.0:
		var vel_dir_world = -ship_velocity.normalized()
		var dot_brake = thrust_force_direction_world.dot(vel_dir_world)
		if dot_brake > 0.1:
			intensity_brake = clamp(dot_brake * motion_component_2d.inertial_dampener_efficiency, 0.0, 1.0)
	
	var intensity = max(intensity_brake, intensity_input)
	
	if intensity > 0.001:
		target_vfx_scale = initial_vfx_scale.y * (1.0 + intensity * vfx_scale_factor)
		target_vfx_energy = initial_vfx_light_energy * intensity
	else:
		target_vfx_scale = initial_vfx_scale.y
		target_vfx_energy = initial_vfx_light_energy
	
	var lerp_factor = clamp(vfx_transition_speed * delta, 0.0, 1.0)
	vfx.scale.y = lerp(vfx.scale.y, target_vfx_scale, lerp_factor)
	vfx.scale.x = initial_vfx_scale.x
	
	if vfx_light:
		var flicker = randf_range(0.0, vfx_random_light_level * 0.2)
		vfx_light.energy = lerp(vfx_light.energy, target_vfx_energy, lerp_factor)
		if intensity > 0.05:
			vfx_light.energy += flicker


func get_current_main_thrust() -> int:
	return current_main_thrust

func get_current_side_thrust() -> int:
	return current_side_thrust
