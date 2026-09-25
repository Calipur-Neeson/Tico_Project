extends CanvasLayer

signal LoadingSceneReady
@export var animation_player: AnimationPlayer
@onready var progress_bar: ProgressBar = $Panel/ProgressBar
@onready var label: Label = $Panel/Label

var updateProgress: float
var isFinished: bool
 
func _ready() -> void:
	isFinished = false
	updateProgress = 0.0
	progress_bar.hide()
	label.hide()
	LoadingSceneReady.connect(ReadyToLoad)
	
	await animation_player.animation_finished
	LoadingSceneReady.emit()

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton:
		if event.pressed:
			GoodToGo()
			isFinished = false

func OnProgressChanged(value: float, delta: float) -> void:
	if value > updateProgress:
		updateProgress = value
	if progress_bar.value < updateProgress:
		progress_bar.value += 0.5 * delta
	else: 
		progress_bar.value = updateProgress * 100
	
func OnLoadFinished() -> void:
	progress_bar.hide()
	label.show()
	isFinished = true

func ReadyToLoad() -> void:
	progress_bar.show()

func GoodToGo() -> void:
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	queue_free()
