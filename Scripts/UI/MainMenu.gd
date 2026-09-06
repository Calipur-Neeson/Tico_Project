extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
func _on_play_button_pressed() -> void:
	SceneLoader.LoadScene(SceneLoader.mainLevelScene)
