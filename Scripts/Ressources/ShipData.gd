extends Resource
class_name ShipData

@export var mass: float
@export var main_thrust_power: float
@export var side_thrust_power: float
@export var max_rotation_speed: float
@export var max_move_speed: float
@export var inertial_dampeners_efficiency: float = 1.0
@export var rotation_dampeners_efficiency : float = 1.0
@export var sprite_texture: Texture2D
@export var collision_shape: Shape2D

func apply_to_ship(ship: Ship):
	var sprite = ship.get_node("Sprite2D")
	if sprite and sprite_texture:
		sprite.texture = sprite_texture

	var collision = ship.get_node("CollisionShape2D")
	if collision and collision_shape:
		collision.shape = collision_shape

	var move_component = ship.get_node("MoveComponent")
	if move_component:
		move_component.apply_data(self)

	var rotation_component = ship.get_node("RotationComponent")
	if rotation_component:
		rotation_component.apply_data(self)
