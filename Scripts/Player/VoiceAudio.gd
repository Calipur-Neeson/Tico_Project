class_name PlayerVoiceAudio
extends AudioStreamPlayer

@export var breathAudio: AudioStream
@export var hurtAudio: AudioStream


func PlayAction(audio: AudioStream) -> void:
	if audio == null:
		return
	stream = audio
	play()
	
func PlayBreath() -> void:
	PlayAction(breathAudio)
func PlayHurt() -> void:
	PlayAction(hurtAudio)
