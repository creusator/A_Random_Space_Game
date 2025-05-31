extends Camera2D
class_name camera

enum MODES { TARGET, TARGET_MOUSE_BLENDED}

@export var target:Node
@export var mode: MODES = MODES.TARGET_MOUSE_BLENDED
@export var smooth_speed: float
@export var zoom_speed:float

var viewport: Vector2
var target_position = Vector2.INF
var max_distance_x: float
var max_distance_y: float
var fallback_target: Node = null
var smoothed_offset: Vector2 = Vector2.ZERO
var zoom_target: Vector2
var max_zoom:float
var min_zoom:float

func _ready():
	viewport = get_viewport_rect().size
	fallback_target = target
	zoom_target = zoom
	max_zoom = 2
	min_zoom = 0.5
	max_distance_x = viewport.x
	max_distance_y = viewport.y

func _process(delta: float) -> void:
	Zoom()
	match(mode):
		MODES.TARGET:
			if target:
				target_position = target.global_position
				if target_position != Vector2.INF:
					global_position = lerp(global_position, target_position, smooth_speed * delta)
		MODES.TARGET_MOUSE_BLENDED:
			if target:
				var mouse_offset = get_global_mouse_position() - target.global_position
				mouse_offset.x = clamp(mouse_offset.x, -max_distance_x, max_distance_x)
				mouse_offset.y = clamp(mouse_offset.y, -max_distance_y, max_distance_y)
				mouse_offset = (mouse_offset * 0.625) / zoom
				smoothed_offset = smoothed_offset.lerp(mouse_offset, clamp(smooth_speed * delta, 0.0, 1.0))
				global_position = target.global_position + smoothed_offset

func Zoom() -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_target *= 1.1
		print("zoomin")
	if Input.is_action_just_pressed("zoom_out"):
		zoom_target *= 0.9
		print("zoomout")
	zoom_target.x = clamp(zoom_target.x, min_zoom, max_zoom)
	zoom_target.y = clamp(zoom_target.y, min_zoom, max_zoom)
	zoom = zoom.lerp(zoom_target, zoom_speed)

func change_camera_mode(new_mode: MODES) -> void:
	mode = new_mode
	
func change_target(new_target: Node) -> void:
	if new_target:
		if target and target.tree_exiting.is_connected(_clear_target):
			target.tree_exiting.disconnect(_clear_target)
		target = new_target
		new_target.tree_exiting.connect(_clear_target)

func _clear_target() -> void:
	target = fallback_target
	change_camera_mode(MODES.TARGET_MOUSE_BLENDED)
