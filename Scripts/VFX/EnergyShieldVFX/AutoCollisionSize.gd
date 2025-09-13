extends Sprite2D

@export var collision_shape: CollisionShape2D

func _ready() -> void:
	_update_sprite_and_shader()

func _update_sprite_and_shader() -> void:
	if collision_shape == null or collision_shape.shape == null:
		return
	
	var shape = collision_shape.shape
	var texture_size = texture.get_size()
	var mat := material as ShaderMaterial
	if mat == null:
		return
	
	var new_size = Vector2.ZERO
	var shape_type = 0
	var radius_px = 0.0
	
	if shape is CircleShape2D:
		new_size = Vector2(shape.radius * 2.0, shape.radius * 2.0)
		shape_type = 0
		radius_px = shape.radius
	elif shape is CapsuleShape2D:
		new_size = Vector2(shape.radius * 2.0, shape.height)
		shape_type = 1
		radius_px = shape.radius / 2
	else:
		return
	
	scale = (new_size / texture_size) * 1.1
	
	mat.set_shader_parameter("shape_size", new_size)
	mat.set_shader_parameter("shape_type", shape_type)
	mat.set_shader_parameter("radius", radius_px)
