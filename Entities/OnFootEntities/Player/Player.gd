class_name Player
extends CharacterBody2D

@onready var player_motion_component_2d: PlayerMotionComponent2D = $PlayerMotionComponent2D
@onready var player_input_component_2d: PlayerInputComponent2D = $PlayerInputComponent2D
@onready var raycast: RayCast2D = $RayCast2D

var prev_pos:Vector2
var global_velocity:Vector2
var sitting: bool = false

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_F):
		sitting = !sitting

func _physics_process(_delta: float) -> void:
	global_rotation = 0.0
	global_velocity = global_position - prev_pos
	raycast.target_position = Vector2(global_velocity.x, global_velocity.y)
	prev_pos = global_position
