class_name ShipIdleState
extends ShipState

func enter() -> void:
	print("Idling")

func physics_update(delta: float) -> void:
	if not is_powered():
		state_machine.transition_to("UnpoweredState")
		return
	
	var input: ShipInputComponent2D = get_input()
	var motion: ShipMotionComponent2D = get_motion()
	var thrust_vector = input.get_thrust_vector()
	var rotation_dir = input.get_rotation_dir()
	
	if thrust_vector != Vector2.ZERO or rotation_dir != 0.0:
		state_machine.transition_to("ShipMovingState")
		return
	
	if ship.velocity.length() < 0.1:
		ship.velocity = Vector2.ZERO
	else:
		ship.velocity = motion.ship_movement_damp(ship.velocity, delta)
	ship.rotation = motion.ship_rotation_damp(delta)
	ship.move_and_slide()
