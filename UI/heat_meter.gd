extends Control

@export var full_texture: Texture2D
@export var normal_texture: Texture2D
@export var low_texture: Texture2D
@export var critical_texture: Texture2D

@onready var meter: TextureRect = $TextureRect


func _ready() -> void:
	set_heat(100)


func set_heat(value: float) -> void:
	value = clamp(value, 0.0, 100.0)

	if value >= 75:
		meter.texture = full_texture

	elif value >= 40:
		meter.texture = normal_texture

	elif value >= 20:
		meter.texture = low_texture

	else:
		meter.texture = critical_texture
