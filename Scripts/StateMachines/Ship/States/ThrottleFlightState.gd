class_name ThrottleFlightState
extends ShipState

func enter() -> void:
	print("Entering Throttle Flight Mode")

func physics_update(delta: float) -> void:
	if not is_powered():
		state_machine.transition_to("UnpoweredState")
		return
	
	var input = get_input()
	var motion = get_motion()
	
	if input.precision_mode == true:
		state_machine.transition_to("PrecisionFlightState")
		return
	
	var thrust_vector = input.get_thrust_vector()
	ship.velocity = motion.player_movement_throttle(
		ship.velocity,
		thrust_vector,
		ship.rotation,
		delta
	)
	
	if input.aim_to_target:
		ship.rotation = motion.aim_to_target(
			ship.position,
			ship.get_global_mouse_position(),
			delta
		)
	else:
		ship.rotation = motion.player_rotation(input.get_rotation_dir(), delta)
	
	ship.move_and_slide()
