extends CanvasLayer

signal LoadingSceneReady
@export var animation_player: AnimationPlayer
 
func _ready() -> void:
	await animation_player.animation_finished
	LoadingSceneReady.emit()

func OnProgressChanged(value: float) -> void:
	pass
	
func OnLoadFinished() -> void:
	animation_player.play_backwards("Transition")
	await animation_player.animation_finished
	queue_free()
