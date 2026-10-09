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

func PlayBell() -> void:
	BGMChange("Bell")

func PlayDetecte() -> void:
	BGMChange("Detecte")

func FadeOut(duration: float = 2.0) -> void:
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80.0, duration)
	tween.tween_callback(StopAudio)
	
func StopAudio() -> void:
	stop()
	volume_db = 0
