extends Node

signal sound_emitted(position: Vector3, volume: float)

func EmitSound(position: Vector3, volume: float) -> void:
	sound_emitted.emit(position, volume)
