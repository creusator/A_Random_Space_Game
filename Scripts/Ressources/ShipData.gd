extends Resource
class_name ShipData

@export var mass: float
@export var main_thrust_power: float
@export var side_thrust_power: float
@export var max_rotation_speed: float
@export var max_move_speed: float
@export var inertial_dampeners_efficiency: float = 1.0
@export var rotation_dampeners_efficiency : float = 1.0

func apply_to_ship(ship: Ship):
	var motion_component = ship.get_node("MotionComponent2D")
	if motion_component:
		motion_component.apply_data(self)
