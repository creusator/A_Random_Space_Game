extends CharacterBody2D
class_name Ship

@export var ship_data: ShipData

@onready var collision_shape = $CollisionShape2D
@onready var move_component = $MoveComponent
@onready var rotation_component = $RotationComponent

var target: Vector2
var thrust_vector: Vector2
var rotation_direction : float

func _ready():
	if ship_data:
		ship_data.apply_to_ship(self)

func _physics_process(delta:float) -> void:
	get_input()
	velocity = move_component.player_movement(velocity, thrust_vector, delta)
	if Input.is_action_pressed('update_aim_point'):
		rotation = rotation_component.aim_to_target(global_position, target, delta)  
	else :
		rotation = rotation_component.player_rotation(rotation_direction, delta)
	move_and_slide()

func get_input() -> void:
	target = get_global_mouse_position()
	thrust_vector = Input.get_vector("thrust_left",
									 "thrust_right",
									 "thrust_up",
									 "thrust_down")
	thrust_vector = thrust_vector.rotated(rotation)
	rotation_direction = Input.get_axis("rotate_left", "rotate_right")
