extends CanvasLayer

signal LoadingSceneReady
@export var animation_player: AnimationPlayer
@onready var progress_bar: ProgressBar = $Panel/ProgressBar

 
func _ready() -> void:
	await animation_player.animation_finished
	LoadingSceneReady.emit()

func OnProgressChanged(value: float) -> void:
	progress_bar.value = value * 100
	
func OnLoadFinished() -> void:
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	queue_free()
