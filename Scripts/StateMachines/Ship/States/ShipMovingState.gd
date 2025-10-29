class_name ShipMovingState
extends ShipState

func enter() -> void:
	print("Moving")

func physics_update(delta: float) -> void:
	if not is_powered():
		state_machine.transition_to("UnpoweredState")
		return
	
	var input: ShipInputComponent2D = get_input()
	var motion: ShipMotionComponent2D = get_motion()
	var thrust_vector = input.get_thrust_vector()
	var rotation_dir = input.get_rotation_dir()
	
	if thrust_vector == Vector2.ZERO and rotation_dir == 0.0:
		state_machine.transition_to("ShipIdleState")
		return
	
	if ship.is_piloted:
		# Rotation
		if input.aim_to_target:
			ship.rotation = motion.aim_to_target(ship.position, ship.get_global_mouse_position(), delta)
		elif rotation_dir != 0.0:
			ship.rotation = motion.ship_rotation(rotation_dir, delta)
		else:
			ship.rotation = motion.ship_rotation_damp(delta)
		
		# Thrusting
		if thrust_vector != Vector2.ZERO:
			if input.precision_mode == false:
				ship.velocity = motion.ship_movement_throttle(ship.velocity, thrust_vector, ship.rotation, delta)
			else:
				ship.velocity = motion.ship_movement_precision(ship.velocity, thrust_vector.rotated(ship.rotation), delta)
		else:
			ship.velocity = motion.ship_movement_damp(ship.velocity, delta)
	
	ship.move_and_slide()
