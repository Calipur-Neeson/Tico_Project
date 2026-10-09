extends CanvasLayer

signal LoadingSceneReady
@export var animation_player: AnimationPlayer
@onready var progress_bar: ProgressBar = $Panel/ProgressBar
@onready var label: Label = $Panel/Label

var updateProgress: float
var isSceneChanged: bool
var isFinished: bool
 
func _ready() -> void:
	isFinished = false
	isSceneChanged = false
	updateProgress = 0.0
	progress_bar.hide()
	label.hide()
	LoadingSceneReady.connect(ReadyToLoad)
	
	await animation_player.animation_finished
	LoadingSceneReady.emit()

func _process(delta: float) -> void:
	if progress_bar.value < updateProgress * 100:
		progress_bar.value += 100 * delta
	
	if progress_bar.value >= 100 and not isSceneChanged:
		isSceneChanged = true
		SceneLoader.ChangeScene()

func _input(event: InputEvent) -> void:
	if event.is_pressed() and isFinished:
		GoodToGo()
		isFinished = false

func OnProgressChanged(value: float) -> void:
	updateProgress = value
	
	
func OnLoadFinished() -> void:
	progress_bar.hide()
	label.show()
	isFinished = true
	
	if GameManager.currentGameState == GameManager.GameState.RESTART:
		GameManager.targetState = GameManager.GameState.PLAYING
	

func ReadyToLoad() -> void:
	progress_bar.show()

func GoodToGo() -> void:
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	GameManager.SetGameState(GameManager.targetState)
	
	if GameManager.currentGameState == GameManager.GameState.PLAYING:
		print("Play ambiance")
		Bgm.PlayAmbiance()
		
	
	queue_free()
