extends AudioStreamPlayer

@onready var playerback: AudioStreamPlaybackInteractive

var current_clip: String = ""
var amountAlarmEnemy: int = 0
var amountPursueEnemy: int = 0

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

func Init() -> void:
	amountAlarmEnemy = 0
	amountPursueEnemy = 0

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
	Init()

func PlayAlarm() -> void:
	BGMChange("Alarm")

func PlayBell() -> void:
	BGMChange("Bell")

func PlayPursued() -> void:
	BGMChange("Pursued")

func StopAudio() -> void:
	BGMChange("None")

func OnEnemyAlarm(a: int) -> void:
	amountAlarmEnemy += a
	EnemyInfluenceBGM()
func OnEnemyPursue(a: int) -> void:
	amountPursueEnemy += a
	EnemyInfluenceBGM()
func EnemyInfluenceBGM() -> void:
	if amountPursueEnemy > 0:
		PlayPursued()
	elif amountAlarmEnemy > 0:
		PlayAlarm()
	elif amountAlarmEnemy == 0 and amountPursueEnemy == 0:
		PlayAmbiance()
