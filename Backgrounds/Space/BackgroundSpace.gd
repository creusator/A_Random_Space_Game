extends ParallaxBackground

@export var front_layer_enabled:bool = true

@onready var background_stars: GPUParticles2D = $Skybox/BackgroundStars
@onready var furthest_layer: ParallaxLayer = $FurthestLayer
@onready var furthest_stars: GPUParticles2D = $FurthestLayer/Stars
@onready var closest_layer: ParallaxLayer = $ClosestLayer
@onready var closest_stars: GPUParticles2D = $ClosestLayer/Stars
@onready var front_layer: ParallaxLayer = $InFrontOfCamera/ParallaxLayer
@onready var front_stars: GPUParticles2D = $InFrontOfCamera/ParallaxLayer/Stars

var reference_resolution: Vector2 = Vector2(1920, 1080)
var base_particle_counts: Dictionary = {}
var current_viewport_size: Vector2i = Vector2i.ZERO

func _ready() -> void:
	store_base_particle_count(background_stars, "background")
	store_base_particle_count(furthest_stars, "furthest")
	store_base_particle_count(closest_stars, "closest")
	store_base_particle_count(front_stars, "front")
	get_viewport().size_changed.connect(_on_viewport_size_changed)
	_on_viewport_size_changed()

func _process(_delta: float) -> void:
	var new_size = get_viewport().size * 2
	if Vector2i(new_size) != current_viewport_size:
		_on_viewport_size_changed()

func store_base_particle_count(particles: GPUParticles2D, key: String) -> void:
	if particles:
		base_particle_counts[key] = particles.amount

func _on_viewport_size_changed() -> void:
	var new_size = get_viewport().size * 2
	
	if Vector2i(new_size) == current_viewport_size:
		return
	
	current_viewport_size = Vector2i(new_size)
	update_parallax_layers(new_size)

func update_parallax_layers(viewport_size: Vector2) -> void:
	var reference_area = reference_resolution.x * reference_resolution.y
	var current_area = viewport_size.x * viewport_size.y
	var density_ratio = current_area / reference_area
	
	update_gpu_particles(background_stars, viewport_size, Vector2.ZERO, density_ratio, "background")
	furthest_layer.motion_mirroring = viewport_size
	update_gpu_particles(furthest_stars, viewport_size, furthest_layer.motion_offset, density_ratio, "furthest")
	closest_layer.motion_mirroring = viewport_size
	update_gpu_particles(closest_stars, viewport_size, closest_layer.motion_offset, density_ratio, "closest")
	if front_layer_enabled : 
		front_layer.motion_mirroring = viewport_size
		update_gpu_particles(front_stars, viewport_size, front_layer.motion_offset, density_ratio, "front")
	else :
		front_layer.hide()

	
func update_gpu_particles(particles: GPUParticles2D, size: Vector2, new_offset: Vector2, density_ratio: float, key: String) -> void:
	if not particles or not particles.process_material:
		return
	if base_particle_counts.has(key):
		var new_amount = int(base_particle_counts[key] * density_ratio)
		if particles.amount != new_amount:
			particles.amount = new_amount
			particles.restart()
	particles.visibility_rect = Rect2(Vector2.ZERO, size)
	var material = particles.process_material as ParticleProcessMaterial
	if material:
		material.emission_shape_offset = Vector3(size.x / 2.0 + new_offset.x, size.y / 2.0 + new_offset.y, 0)
		material.emission_shape_scale = Vector3(size.x / 2.0, size.y / 2.0, 0)
