class_name Thruster
extends ShipComponent

@onready var vfx: GPUParticles2D = $GPUParticles2D
@export var data: ThrusterData

# Stats
var mass: int
var main_thrust_power: int
var side_thrust_power: int
var power_consumption: int
var fuel_consumption: float
var current_main_thrust: int = 0
var current_side_thrust: int = 0

# VFX - Technicals
var thruster_orientation: Vector2 = Vector2.UP
var random = RandomNumberGenerator.new()
var vfx_light: PointLight2D
var initial_vfx_scale: Vector2 = Vector2.ONE

# VFX - Visuals
var target_vfx_scale: float = 1.0
var target_vfx_energy: float = 0.4
var vfx_transition_speed: float = 6.0
var random_light_timer: float = 0.0
var initial_vfx_light_energy: float = 0.5
var vfx_scale_factor: float = 1.0
var vfx_random_light_level: float = 0.0

var ship: Ship

func _ready() -> void:
	super()
	random.randomize()
	
	ship = get_parent().get_parent()
	
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
	random_light_timer -= delta
	
	if random_light_timer <= 0.0:
		random_light_timer = random.randf_range(0.5, 3.0)
		vfx_random_light_level = random.randf_range(0.0, 0.4)
	
	if vfx and ship:
		update_vfx(delta)

func on_powered() -> void:
	current_main_thrust = main_thrust_power
	current_side_thrust = side_thrust_power

func on_unpowered() -> void:
	current_main_thrust = 0
	current_side_thrust = 0

func update_vfx(delta: float) -> void:
	if not is_operational():
		vfx.scale = Vector2.ZERO
		if vfx_light:
			vfx_light.energy = 0.0
		return
	
	var ship_rotation = ship.rotation
	var ship_velocity = ship.velocity
	var motion = ship.motion_component_2d
	var input = ship.input_component_2d
	
	var thrust_force_direction_world = thruster_orientation.rotated(ship_rotation).normalized()
	var thrust_input_local: Vector2
	var thrust_input_world: Vector2
	
	if ship.is_piloted:
		thrust_input_local = input.get_thrust_vector()
		thrust_input_world = thrust_input_local.rotated(ship_rotation)
	else :
		thrust_input_local = Vector2.ZERO
		thrust_input_world = Vector2.ZERO
	
	# Poussée linéaire
	var intensity_input := 0.0
	
	if thrust_input_world.length() > 0.01:
		var input_dir_world = thrust_input_world.normalized()
		var dot_in = thrust_force_direction_world.dot(input_dir_world)
		if dot_in > 0.1:
			intensity_input = clamp(dot_in * thrust_input_world.length(), 0.0, 1.0)
	
	var intensity_brake := 0.0
	var speed = ship_velocity.length()
	var braking_intent := false
	
	if thrust_input_world.length() < 0.01 and speed > 1.0:
		braking_intent = true
	elif thrust_input_world.length() > 0.1:
		var dot_velocity = ship_velocity.normalized().dot(thrust_input_world.normalized())
		if dot_velocity < -0.25:
			braking_intent = true
	
	if braking_intent and motion.inertial_dampener_efficiency > 0.0:
		var vel_dir_world = -ship_velocity.normalized()
		var dot_brake = thrust_force_direction_world.dot(vel_dir_world)
		if dot_brake > 0.1:
			intensity_brake = clamp(dot_brake * motion.inertial_dampener_efficiency, 0.0, 1.0)
	
	var intensity_translation = max(intensity_brake, intensity_input)
	
	# Rotation
	var intensity_rotation := 0.0
	
	if side_thrust_power > 0:
		var rotation_input: float
		if ship.is_piloted :
			rotation_input = input.get_rotation_dir()
		else:
			rotation_input = 0.0
		
		var angular_velocity = motion.angular_velocity_rad
		var thruster_pos_local = position
		var thruster_arm = thruster_pos_local.length()
		
		if thruster_arm > 0.1:
			var thrust_dir_local = thruster_orientation
			var torque_contribution = thruster_pos_local.cross(thrust_dir_local)
			
			if abs(rotation_input) > 0.01:
				if sign(torque_contribution) == sign(rotation_input):
					intensity_rotation = abs(rotation_input)
			elif abs(angular_velocity) > 0.01 and motion.rotation_dampeners_efficiency > 0.0:
				if sign(torque_contribution) == sign(angular_velocity):
					var max_angular = motion.max_rotation_speed
					var angular_ratio = clamp(abs(angular_velocity) / max_angular, 0.0, 1.0)
					intensity_rotation = angular_ratio * motion.rotation_dampeners_efficiency
	
	# Affichage
	var intensity = max(intensity_translation, intensity_rotation)
	var lerp_factor = clamp(vfx_transition_speed * delta, 0.0, 1.0)
	
	if intensity > 0.001:
		target_vfx_scale = initial_vfx_scale.y * (1.0 + intensity * vfx_scale_factor)
		target_vfx_energy = initial_vfx_light_energy * intensity
	else:
		target_vfx_scale = initial_vfx_scale.y
		target_vfx_energy = initial_vfx_light_energy
	
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
