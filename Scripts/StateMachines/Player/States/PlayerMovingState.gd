class_name PlayerMovingState
extends PlayerState

func physics_update(_delta: float) -> void:
	var input: PlayerInputComponent2D = player.player_input_component_2d
	var motion: PlayerMotionComponent2D = player.player_motion_component_2d
	var walk_dir: Vector2 = input.get_direction_vector()
	
	if player.sitting == false:
		# Vélocité locale (relative au parent)
		player.velocity = motion.move(walk_dir)
	
	if abs(player.velocity) > Vector2.ZERO:
		player.rotation = player.velocity.angle() + PI / 2
	
	# Move and slide suit automatiquement le parent
	player.move_and_slide()
	
	if walk_dir == Vector2.ZERO and player.velocity == Vector2.ZERO:
		state_machine.transition_to("PlayerIdleState")
