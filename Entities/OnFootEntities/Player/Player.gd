class_name Player
extends CharacterBody2D

@onready var player_motion_component_2d: PlayerMotionComponent2D = $PlayerMotionComponent2D
@onready var player_input_component_2d: PlayerInputComponent2D = $PlayerInputComponent2D
@onready var interior_raycast: RayCast2D = $InteriorRayCast
@onready var sprite: Sprite2D = $Sprite2D

signal entered_ship(ship:Ship)
signal exited_ship

var sitting: bool = false

var current_zone: Area2D = null
var original_parent: Node = null

func _ready() -> void:
	original_parent = get_parent()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("onfoot_interact"):
		sitting = !sitting

func _physics_process(_delta: float) -> void:
	interior_raycast.target_position = Vector2.ZERO
	
	var collider = interior_raycast.get_collider()
	
	if collider != current_zone:
		current_zone = collider
		
		var target_parent: Node
		if collider:
			target_parent = collider
			entered_ship.emit(target_parent.get_parent().ship)
		else:
			target_parent = original_parent
			exited_ship.emit()
		if get_parent() != target_parent:
			reparent(target_parent)
			owner = target_parent
