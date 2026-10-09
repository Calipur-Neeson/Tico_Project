extends AudioStreamPlayer

@onready var playerback: AudioStreamPlaybackInteractive

var current_clip: String = ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	play()
	playerback = get_stream_playback()
	
	if playerback == null:
		return
	
	if GameManager.currentGameState == GameManager.GameState.MENU:
		BGMChange("Menu")
	else:
		BGMChange("Ambiance")

func BGMChange(clipName: String) -> void:
	if current_clip == clipName:
		return

	if not is_playing():
		play()
		playerback = get_stream_playback()
		
	if playerback == null:
		return

	playerback.switch_to_clip_by_name(clipName)
	current_clip = clipName

func PlayMenu() -> void:
	BGMChange("Menu")

func PlayAmbiance() -> void:
	BGMChange("Ambiance")

func PlayAlarm() -> void:
	BGMChange("Alarm")

func PlayDetecte() -> void:
	BGMChange("Detecte")
