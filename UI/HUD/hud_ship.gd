extends Control

@export var ship:Ship
@onready var throttle: ProgressBar = $VBoxContainer/Throttle
@onready var precision_mode: Label = $VBoxContainer/PrecisionMode

var ship_throttle_value:float = 0.0

func _ready() -> void:
	ship_throttle_value = 0
	

func _process(_delta: float) -> void:
	ship_throttle_value = ship.get_throttle_state()
	throttle.update(ship_throttle_value)
	precision_mode.text = ("Precision mode : " + str(ship.get_precision_state()))
