extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.cfg"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		
		config.set_value("video", "window_mode", 1)
		config.set_value("video", "resolution", 1)
		config.set_value("video", "antialiasing", 2)
		config.set_value("video", "vsync", true)
		config.set_value("video", "fps_cap", 200)
		
		config.set_value("camera", "camera_mode", 1)
		
		config.set_value("controls", "throttle_deadzone", 0.2)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
	
	apply_settings()

func apply_settings() -> void:
	var window_mode_index = config.get_value("video", "window_mode", 1)
	var resolution_index = config.get_value("video", "resolution", 1)
	var antialiasing_index = config.get_value("video", "antialiasing", 2)
	var vsync = config.get_value("video", "vsync", true)
	var fps_cap = config.get_value("video", "fps_cap", 200)
	var camera_mode = config.get_value("camera", "camera_mode", 1)
	var throttle_deadzone = config.get_value("controls", "throttle_deadzone", 0.2)
	
	var root_viewport = get_tree().root.get_viewport_rid()
	match window_mode_index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	match resolution_index:
		0:
			var new_size = Vector2i(1280, 720)
			DisplayServer.window_set_size(new_size)
			get_tree().root.size = new_size
		1:
			var new_size = Vector2i(1920, 1080)
			DisplayServer.window_set_size(new_size)
			get_tree().root.size = new_size
		2:
			var new_size = Vector2i(2560, 1440)
			DisplayServer.window_set_size(new_size)
			get_tree().root.size = new_size
	
	match antialiasing_index:
		0:
			RenderingServer.viewport_set_screen_space_aa(root_viewport, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_DISABLED)
		1:
			RenderingServer.viewport_set_screen_space_aa(root_viewport, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_FXAA)
		2:
			RenderingServer.viewport_set_screen_space_aa(root_viewport, RenderingServer.VIEWPORT_SCREEN_SPACE_AA_SMAA)
	
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	Engine.max_fps = fps_cap
	
	GlobalVariables.camera_mode = camera_mode
	GlobalVariables.throttle_deadzone = throttle_deadzone
