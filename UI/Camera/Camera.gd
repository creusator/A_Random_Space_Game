extends Camera2D
class_name camera

enum MODES { TARGET, TARGET_MOUSE_BLENDED}

@export var target:Node
@export var mode: MODES = MODES.TARGET_MOUSE_BLENDED
@export var smooth_speed: float
@export var zoom_speed:float
@export var max_zoom:float
@export var min_zoom:float

var viewport: Vector2
var mouse_offset: Vector2
var target_position = Vector2.INF
var max_distance_x: float
var max_distance_y: float
var fallback_target: Node = null
var smoothed_offset: Vector2 = Vector2.ZERO
var zoom_target: Vector2

func _ready():
	viewport = get_viewport_rect().size
	max_distance_x = viewport.x
	max_distance_y = viewport.y
	fallback_target = target
	zoom_target = zoom

func _process(delta: float) -> void:
	CameraZoom()
	CameraMove(delta)

func CameraMove(delta) -> void:
	match(mode):
		MODES.TARGET:
			if target:
				target_position = target.global_position
				if target_position != Vector2.INF:
					global_position = lerp(global_position, target_position, smooth_speed * delta)
		MODES.TARGET_MOUSE_BLENDED:
			if target:
				viewport = get_viewport_rect().size
				max_distance_x = viewport.x / 2
				max_distance_y = viewport.y / 2
				mouse_offset = get_global_mouse_position() - target.global_position
				mouse_offset.x = clamp(mouse_offset.x, -max_distance_x, max_distance_x)
				mouse_offset.y = clamp(mouse_offset.y, -max_distance_y, max_distance_y)
				smoothed_offset = smoothed_offset.lerp(mouse_offset / zoom, clamp(smooth_speed * delta, 0.0, 1.0))
				global_position = target.global_position + smoothed_offset

func CameraZoom() -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_target *= 1.1
		print("zoomin")
	if Input.is_action_just_pressed("zoom_out"):
		zoom_target *= 0.9
		print("zoomout")
	zoom_target.x = clamp(zoom_target.x, min_zoom, max_zoom)
	zoom_target.y = clamp(zoom_target.y, min_zoom, max_zoom)
	zoom = zoom.lerp(zoom_target, zoom_speed)
