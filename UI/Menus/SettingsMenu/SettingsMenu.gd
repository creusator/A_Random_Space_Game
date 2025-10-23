extends Control

@onready var window_mode_dropdown: OptionButton = $MarginContainer/VBoxContainer/Video/WindowModeContainer/OptionButton
@onready var resolution_dropdown: OptionButton = $MarginContainer/VBoxContainer/Video/ResolutionContainer/OptionButton
@onready var antialiasing_dropdown: OptionButton = $MarginContainer/VBoxContainer/Video/AAContainer/OptionButton
@onready var vsync_box: CheckBox = $MarginContainer/VBoxContainer/Video/VsyncContainer/CheckBox
@onready var fps_slider: HSlider = $MarginContainer/VBoxContainer/Video/FpsCapContainer/HSlider
@onready var fps_box: SpinBox = $MarginContainer/VBoxContainer/Video/FpsCapContainer/SpinBox
@onready var camera_dropdown: OptionButton = $MarginContainer/VBoxContainer/Camera/CameraMode
@onready var throttle_slider: HSlider = $MarginContainer/VBoxContainer/Controls/ThrottleDeadzoneContainer/HSlider
@onready var throttle_box: SpinBox = $MarginContainer/VBoxContainer/Controls/ThrottleDeadzoneContainer/SpinBox

#Graphics
var window_mode_index:int = 1
var resolution_index:int = 1
var antialiasing_index:int = 2
var vsync:bool = true
var fps_cap:int = 200

#Camera
var camera_mode = 1

#Controls
var throttle_deadzone:float = 0.02

func _ready() -> void:
	load_settings()

func load_settings() -> void:
	window_mode_index = ConfigFilerHandler.config.get_value("video", "window_mode", 1)
	resolution_index = ConfigFilerHandler.config.get_value("video", "resolution", 1)
	antialiasing_index = ConfigFilerHandler.config.get_value("video", "antialiasing", 2)
	vsync = ConfigFilerHandler.config.get_value("video", "vsync", true)
	fps_cap = ConfigFilerHandler.config.get_value("video", "fps_cap", 200)
	camera_mode = ConfigFilerHandler.config.get_value("camera", "camera_mode", 1)
	throttle_deadzone = ConfigFilerHandler.config.get_value("controls", "throttle_deadzone", 0.2)
	window_mode_dropdown.selected = window_mode_index
	resolution_dropdown.selected = resolution_index
	antialiasing_dropdown.selected = antialiasing_index
	vsync_box.button_pressed = vsync
	fps_slider.value = fps_cap
	fps_box.value = fps_cap
	camera_dropdown.selected = camera_mode
	throttle_slider.value = throttle_deadzone
	throttle_box.value = throttle_deadzone

func save_settings() -> void:
	ConfigFilerHandler.config.set_value("video", "window_mode", window_mode_index)
	ConfigFilerHandler.config.set_value("video", "resolution", resolution_index)
	ConfigFilerHandler.config.set_value("video", "antialiasing", antialiasing_index)
	ConfigFilerHandler.config.set_value("video", "vsync", vsync)
	ConfigFilerHandler.config.set_value("video", "fps_cap", fps_cap)
	ConfigFilerHandler.config.set_value("camera", "camera_mode", camera_mode)
	ConfigFilerHandler.config.set_value("controls", "throttle_deadzone", throttle_deadzone)
	
	var err = ConfigFilerHandler.config.save(ConfigFilerHandler.SETTINGS_FILE_PATH)
	if err != OK:
		printerr("Save failed : ", err)

func _on_window_mode_selected(index: int) -> void:
	window_mode_index = index

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
	save_settings()
	ConfigFilerHandler.apply_settings()
