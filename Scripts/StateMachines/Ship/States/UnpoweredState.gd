class_name UnpoweredState
extends ShipState

func enter() -> void:
	print("Ship lost power! Drifting...")

func physics_update(delta: float) -> void:
	if is_powered():
		state_machine.transition_to("ShipIdleState")
		return
	
	var motion = get_motion()
	ship.rotation += motion.angular_velocity_rad * delta
	ship.move_and_slide()
