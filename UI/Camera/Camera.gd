class_name Camera
extends Camera2D

@export var target: Node
@export var camera_smooth_speed: float
@export var zoom_speed: float = 5.0
@export var max_zoom: float = 2.0
@export var min_zoom: float = 0.6
@export var mouse_influence_radius: float = 200.0
@export var mouse_influence_strength: float = 0.5

@onready var original_target = target
@onready var current_mode: int = GlobalVariables.camera_mode

var viewport: Vector2
var target_position: Vector2 = Vector2.INF
var zoom_target: Vector2 = Vector2.ONE
var fallback_target: Node = null
var mouse_offset: Vector2 = Vector2.ZERO

func _ready():
	viewport = get_viewport_rect().size
	fallback_target = target
	zoom_target = zoom
	if target is Player:
		target.entered_ship.connect(_on_player_entered_ship)
		target.exited_ship.connect(_on_player_exited_ship)

func _physics_process(delta: float) -> void:
	var target_piloting:bool = target is Ship and target.is_piloted == true
	var target_on_foot_inside:bool = target is Ship and target.is_piloted == false
	var target_on_foot_outside:bool = target is Player and target.sitting == false
	
	if target_piloting or target_on_foot_outside :
		current_mode = GlobalVariables.camera_mode
	elif target_on_foot_inside:
		current_mode = 2
	
	CameraZoom(delta)
	CameraRotate(delta)
	CameraMove(delta)

func CameraMove(delta: float) -> void:
	if not target:
		return
		
	match current_mode:
		0: #Mode target
			target_position = target.global_position
			if target_position != Vector2.INF:
				global_position = target_position
		1: #Mode target mouse blended
			target_position = target.global_position
			var mouse_pos = get_global_mouse_position()
			var mouse_dist = (mouse_pos - target_position).length()
			var influence = clamp(mouse_dist / mouse_influence_radius, 0.0, 1.0)
			var desired_mouse_offset = (mouse_pos - target_position) * influence * mouse_influence_strength
			mouse_offset = mouse_offset.lerp(desired_mouse_offset, camera_smooth_speed * delta)
			global_position = target_position + mouse_offset
		2: #Mode interior
			target_position = target.global_position
			if target_position != Vector2.INF:
				global_position = target_position

func CameraRotate(delta: float) -> void:
	if not target:
		return
	
	var target_angular_velocity: float = 0.0
	var target_rotation:float = 0.0
	
	match current_mode:
		0: # Mode target
			target_rotation = 0.0
		1: # Mode target mouse blended
			target_rotation = 0.0
		2: # Mode interior
			target_rotation = target.global_rotation
			target_angular_velocity = target.motion_component_2d.angular_velocity_rad
	
	var angle_diff = angle_difference(global_rotation, target_rotation)
	var smooth_correction = angle_diff * camera_smooth_speed
	var velocity_correction = target_angular_velocity
	if abs(angle_diff) >= 0.0 : #0.92 is a magic number to eliminate shifting
		global_rotation += (smooth_correction + velocity_correction)* 0.92 * delta
	else:
		global_rotation = target_rotation

func CameraZoom(delta: float) -> void:
	if not target:
		return
	
	if current_mode == 2 :
		zoom = zoom.lerp(Vector2(max_zoom, max_zoom), zoom_speed * delta)
	else :
		if Input.is_action_just_pressed("zoom_in"):
			zoom_target *= 1.1
		if Input.is_action_just_pressed("zoom_out"):
			zoom_target *= 0.9
		zoom_target.x = clamp(zoom_target.x, min_zoom, max_zoom)
		zoom_target.y = clamp(zoom_target.y, min_zoom, max_zoom)
		zoom = zoom.lerp(zoom_target, zoom_speed * delta)

func _on_player_entered_ship(ship):
	set_target(ship)

func _on_player_exited_ship():
	set_target(original_target)

func set_target(new_target:Node2D):
	target = new_target
