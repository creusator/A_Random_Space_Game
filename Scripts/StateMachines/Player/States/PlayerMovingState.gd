class_name PlayerMovingState
extends PlayerState

func physics_update(_delta: float) -> void:
	var input: PlayerInputComponent2D = player.player_input_component_2d
	var motion: PlayerMotionComponent2D = player.player_motion_component_2d
	var walk_dir: Vector2 = input.get_direction_vector().rotated(player.get_parent().global_rotation)
	
	if player.sitting == false:
		player.velocity = motion.move(walk_dir)
	
	if abs(player.velocity) > Vector2.ZERO:
		player.sprite.rotation = player.velocity.angle() + PI / 2
	
	player.move_and_slide()
	
	if walk_dir == Vector2.ZERO and player.velocity == Vector2.ZERO:
		state_machine.transition_to("PlayerIdleState")
