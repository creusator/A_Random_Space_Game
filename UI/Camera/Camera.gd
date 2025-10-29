class_name Camera
extends Camera2D

@export var target: Node
@export var camera_smooth_speed: float
@export var zoom_speed: float = 5.0
@export var max_zoom: float = 2.0
@export var min_zoom: float = 0.6
@export var mouse_influence_radius: float = 200.0 
@export var mouse_influence_strength: float = 0.5

var viewport: Vector2
var target_position: Vector2 = Vector2.INF
var zoom_target: Vector2 = Vector2.ONE
var fallback_target: Node = null
var mouse_offset: Vector2 = Vector2.ZERO

func _ready():
	viewport = get_viewport_rect().size
	fallback_target = target
	zoom_target = zoom

func _physics_process(delta: float) -> void:
	CameraZoom(delta)
	CameraMove(delta)

func CameraMove(delta: float) -> void:
	if not target:
		return
	
	match GlobalVariables.camera_mode:
		0:  #Mode target
			target_position = target.global_position
			if target_position != Vector2.INF:
				global_position = target_position
				
		1:  #Mode target mouse blended
			var target_pos = target.global_position
			var mouse_pos = get_global_mouse_position()
			var mouse_dist = (mouse_pos - target_pos).length()
			var influence = clamp(mouse_dist / mouse_influence_radius, 0.0, 1.0)
			var desired_mouse_offset = (mouse_pos - target_pos) * influence * mouse_influence_strength
			mouse_offset = mouse_offset.lerp(desired_mouse_offset, camera_smooth_speed * delta)
			global_position = target_pos + mouse_offset

func CameraZoom(delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_target *= 1.1
	if Input.is_action_just_pressed("zoom_out"):
		zoom_target *= 0.9
	
	zoom_target.x = clamp(zoom_target.x, min_zoom, max_zoom)
	zoom_target.y = clamp(zoom_target.y, min_zoom, max_zoom)
	zoom = zoom.lerp(zoom_target, zoom_speed * delta)
