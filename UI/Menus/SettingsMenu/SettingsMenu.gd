extends Control

@onready var fps_slider: HSlider = $MarginContainer/VBoxContainer/Graphics/FpsCapContainer/HSlider
@onready var fps_box: SpinBox = $MarginContainer/VBoxContainer/Graphics/FpsCapContainer/SpinBox
@onready var throttle_slider: HSlider = $MarginContainer/VBoxContainer/Controls/ThrottleDeadzoneContainer/HSlider
@onready var throttle_box: SpinBox = $MarginContainer/VBoxContainer/Controls/ThrottleDeadzoneContainer/SpinBox

#Graphics
var resolution_index:int = 1
var antialiasing_index:int = 2
var vsync:bool = true
var fps_cap:int = 200

#Camera
var camera_mode = 1

#Controls
var throttle_deadzone:float = 0.02

func _on_resolution_selected(index: int) -> void:
	resolution_index = index

func _on_antialiasing_selected(index: int) -> void:
	antialiasing_index = index

func _on_vsync_toggled(toggled_on: bool) -> void:
	vsync = toggled_on

func _on_fps_cap_slide_changed(value: float) -> void:
	fps_cap = int(value)
	fps_box.value = int(value)

func _on_fsp_cap_box_changed(value: float) -> void:
	fps_cap = int(value)
	fps_slider.value = int(value)

func _on_camera_mode_selected(index: int) -> void:
	camera_mode = index

func _on_throttle_slider_changed(value: float) -> void:
	throttle_deadzone = value
	throttle_box.value = value

func _on_throttle_boxs_changed(value: float) -> void:
	throttle_deadzone = value
	throttle_slider.value = value

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(GlobalVariables.previous_scene)

func _on_apply_pressed() -> void:
	#Graphics
	var root_viewport = get_tree().root.get_viewport_rid()
	match resolution_index:
		0:
			var new_size = Vector2i(1280, 720)
			DisplayServer.window_set_size(new_size)
			get_tree().root.size = new_size
			await get_tree().process_frame
		1:
			var new_size = Vector2i(1920, 1080)
			DisplayServer.window_set_size(new_size)
			get_tree().root.size = new_size
			await get_tree().process_frame
		2:
			var new_size = Vector2i(2560, 1440)
			DisplayServer.window_set_size(new_size)
			get_tree().root.size = new_size
			await get_tree().process_frame
	
	match antialiasing_index:
		0:
			RenderingServer.viewport_set_screen_space_aa(root_viewport,RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
		1:
			RenderingServer.viewport_set_screen_space_aa(root_viewport,RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
		2:
			RenderingServer.viewport_set_screen_space_aa(root_viewport,RenderingServer.VIEWPORT_SCREEN_SPACE_AA_SMAA)
	
	match vsync:
		true:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		false:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	Engine.max_fps = fps_cap
	
	#Camera
	GlobalVariables.camera_mode = camera_mode
	
	#Controls
	GlobalVariables.throttle_deadzone = throttle_deadzone
