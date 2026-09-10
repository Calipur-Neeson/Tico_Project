extends Control

@onready var active: TextureProgressBar = $Active

@export var max_heat: float = 100.0
@export var transition_speed: float = 10.0

var current_heat: float = 100.0
var target_heat: float = 100.0


func _ready() -> void:
	active.min_value = 0.0
	active.max_value = max_heat
	active.value = current_heat

	# Temporary test
	set_heat(10.0)


func _process(delta: float) -> void:
	current_heat = move_toward(
		current_heat,
		target_heat,
		transition_speed * delta
	)

	active.value = current_heat


func set_heat(value: float) -> void:
	target_heat = clamp(value, 0.0, max_heat)


func remove_heat(amount: float) -> void:
	set_heat(target_heat - amount)


func add_heat(amount: float) -> void:
	set_heat(target_heat + amount)
