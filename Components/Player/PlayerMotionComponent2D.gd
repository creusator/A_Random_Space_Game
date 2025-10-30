class_name PlayerMotionComponent2D
extends MotionComponent2D

@export var controlled:Player

var max_walking_speed:int

const PIXEL_PER_METER = GlobalVariables.PIXEL_PER_METER

func move(dir:Vector2) -> Vector2:
	return dir.normalized() * GlobalVariables.PIXEL_PER_METER * 5
