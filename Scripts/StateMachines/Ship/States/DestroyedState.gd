class_name DestroyedState
extends ShipState

func enter() -> void:
	print("Ship destroyed")
	ship.queue_free()
