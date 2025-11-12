extends CharacterBody2D

@onready var control: Control = $"../.."

func _physics_process(delta: float) -> void:
	control.rotation += 0.5 * delta
	velocity.x = 150
	rotation += 5 * delta
	move_and_slide()
