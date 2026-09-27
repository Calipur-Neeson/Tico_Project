extends CanvasLayer

var isPaused: bool = false

@onready var panel: Panel = $Panel
@onready var resume_button: Button = $Panel/PanelContainer/VBoxContainer/ResumeButton


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		if isPaused:
			Resume()
		else:
			Pause()
		
		isPaused = not isPaused

func Pause() -> void:
	GameManager.SetGameState(GameManager.GameState.PAUSE)
	GameManager.OnGameStateChanged.emit(GameManager.currentGameState)
	panel.modulate.a = 255
	get_tree().paused = true
	if GameManager.currentInputMode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif GameManager.currentInputMode == GameManager.InputMode.CONTROLLER:
		resume_button.grab_focus()
	
func Resume() -> void:
	GameManager.SetGameState(GameManager.GameState.PLAYING)
	GameManager.OnGameStateChanged.emit(GameManager.currentGameState)
	panel.modulate.a = 0
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_button_pressed() -> void:
	Resume()

func _on_setting_button_pressed() -> void:
	pass # Replace with function body.

func _on_restart_button_pressed() -> void:
	Resume()
	GameManager.SetGameState(GameManager.GameState.RESTART)
	SceneLoader.LoadScene(SceneLoader.mainLevelScene)


func _on_menu_button_pressed() -> void:
	Resume()
	GameManager.SetGameState(GameManager.GameState.MENU)
	GameManager.OnGameStateChanged.emit(GameManager.currentGameState)
	SceneLoader.LoadScene(SceneLoader.mainMenuScene)
