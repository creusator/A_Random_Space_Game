class_name DestroyedState
extends ShipState

func enter() -> void:
	ship.queue_free()
