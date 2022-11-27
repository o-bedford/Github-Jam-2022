extends Control
class_name SPMeter

const METER_SPEED: float = 0.4

var SP_value: int

onready var meter: TextureProgress = $Meter

func _process(delta: float) -> void:
	if meter.value != SP_value:
		meter.value = lerp(meter.value, SP_value, METER_SPEED)
#	print(meter.value)

func set_value(value: int) -> void:
	SP_value = value
#	print(SP_value)
