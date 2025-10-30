class_name ShipIdleState
extends ShipState

func physics_update(_delta: float) -> void:
	if not is_powered():
		state_machine.transition_to("ShipUnpoweredState")
		return
	
	var input: ShipInputComponent2D = get_input()
	var thrust_vector = input.get_thrust_vector()
	var rotation_dir = input.get_rotation_dir()
	
	if ship.is_piloted and (thrust_vector != Vector2.ZERO or rotation_dir != 0.0):
		state_machine.transition_to("ShipMovingState")
		return
	
	ship.move_and_slide()
