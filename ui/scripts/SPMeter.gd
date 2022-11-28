extends Control
class_name SPMeter

const METER_SPEED: float = 0.4

export var win_condition: int = 12

var SP_value: int

onready var meter: TextureProgress = $Meter

func _ready() -> void:
	meter.min_value = -win_condition
	meter.max_value = win_condition

func _process(delta: float) -> void:
	if meter.value != SP_value:
		meter.value = lerp(meter.value, SP_value, METER_SPEED)
#	print(meter.value)

func set_value(value: int) -> void:
	SP_value = value
#	print(SP_value)
