class_name PlayerActionAudio
extends AudioStreamPlayer

@export var climbAudio: AudioStream
@export var jumpAudio: AudioStream
@export var landAudio: AudioStream
@export var throwAudio: AudioStream

func PlayAction(audio: AudioStream) -> void:
	if audio == null:
		return
	stream = audio
	play()

func PlayClimb() -> void:
	PlayAction(climbAudio)
func PlayJump() -> void:
	PlayAction(jumpAudio)
func PlayLand() -> void:
	PlayAction(landAudio)
func PlayThrow() -> void:
	PlayAction(throwAudio)
