class_name PlayerIdleState
extends PlayerState

func physics_update(_delta: float) -> void:
	var input: PlayerInputComponent2D = player.player_input_component_2d
	var walk_dir:Vector2 = input.get_direction_vector()
	
	if walk_dir != Vector2.ZERO and player.sitting == false:
		state_machine.transition_to("PlayerMovingState")
	
	player.move_and_slide()
