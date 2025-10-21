extends ProgressBar

func update(ship_throttle_value:float) -> void:
	set_value_no_signal(ship_throttle_value * 100)
