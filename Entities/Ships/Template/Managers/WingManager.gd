extends Node2D
class_name WingManager

signal wing_destroyed

var total_wing_mass:int = 0

func _ready() -> void:
	for wing:Wing in self.get_children():
		total_wing_mass += wing.mass
		wing.wing_destroyed.connect(_on_wing_destroyed)

func _on_wing_destroyed(wing:Wing):
	total_wing_mass -= wing.mass
	wing_destroyed.emit()
