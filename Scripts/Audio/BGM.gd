extends AudioStreamPlayer

@onready var playerback: AudioStreamPlaybackInteractive = get_stream_playback()

func _ready() -> void:
	play()
	
func BGMChange(clipName: String) -> void:
	if playerback.is_playing():
		playerback.switch_to_clip_by_name(clipName)
