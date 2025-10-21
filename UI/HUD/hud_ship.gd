extends Control

@export var ship:Ship
@onready var forward_throttle: ProgressBar = $VBoxContainer/ForwardThrottle
@onready var backward_throttle: ProgressBar = $VBoxContainer/BackwardThrottle
@onready var precision_mode: Label = $VBoxContainer/PrecisionMode

var ship_throttle_value:float = 0.0

func _ready() -> void:
	ship_throttle_value = 0
	

func _process(_delta: float) -> void:
	if not ship:
		return
	ship_throttle_value = ship.get_throttle_state()
	if ship_throttle_value >= 0.0:
		forward_throttle.set_value_no_signal(ship_throttle_value*100)
		backward_throttle.set_value_no_signal(0.0)
	else:
		forward_throttle.set_value_no_signal(0.0)
		backward_throttle.set_value_no_signal(abs(ship_throttle_value)*100)
	precision_mode.text = ("Precision mode : " + str(ship.get_precision_state()))
