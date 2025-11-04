class_name Player
extends CharacterBody2D

@onready var player_motion_component_2d: PlayerMotionComponent2D = $PlayerMotionComponent2D
@onready var player_input_component_2d: PlayerInputComponent2D = $PlayerInputComponent2D
@onready var raycast: RayCast2D = $RayCast2D

var sitting: bool = false

var current_zone: Area2D = null
var original_parent: Node = null

func _ready() -> void:
	original_parent = get_parent()

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_F):
		sitting = !sitting

func _physics_process(_delta: float) -> void:
	global_rotation = 0.0
	raycast.target_position = Vector2.ZERO
	
	var collider = raycast.get_collider()
	
	if collider != current_zone:
		current_zone = collider
		
		var target_parent: Node
		if collider:
			target_parent = collider
			print("Entered : ", collider.name)
		else:
			target_parent = original_parent
		
		if get_parent() != target_parent:
			reparent(target_parent)
			owner = target_parent
