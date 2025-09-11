extends Sprite2D

@export var collision_shape: CollisionShape2D

func _ready() -> void:
	_update_sprite_and_shader()

func _update_sprite_and_shader() -> void:
	if collision_shape == null or collision_shape.shape == null:
		push_error("No valid CollisionShape2D assigned")
		return
	var shape = collision_shape.shape
	var texture_size = texture.get_size()
	if material == null:
		push_error("You forgot the shader material dumbass")
		return
	var new_size = Vector2.ZERO
	if shape is RectangleShape2D:
		new_size = shape.extents * 2.0
	elif shape is CircleShape2D:
		new_size = Vector2(shape.radius * 2.0, shape.radius * 2.0)
	elif shape is CapsuleShape2D:
		new_size = Vector2(shape.radius * 2.0, shape.height + shape.radius * 2.0)
	else:
		push_warning("Unsupported CollisionShape2D shape")
		return
	scale = new_size / texture_size
	material.set_shader_parameter("shape_size", new_size)
