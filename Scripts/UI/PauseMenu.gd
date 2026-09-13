extends CanvasLayer

var isPaused: bool = false

@onready var panel: Panel = $Panel
@onready var resume_button: Button = $Panel/PanelContainer/VBoxContainer/ResumeButton

@onready var save_game_popup: Control = $Panel/SaveGame_popup
@onready var game_saved: Label = $"Panel/Game Saved"


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Escape"):
		if isPaused:
			Resume()
		else:
			Pause()
		
		isPaused = not isPaused

func Pause() -> void:
	panel.modulate.a = 255
	get_tree().paused = true
	if GameManager.currentInputMode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif GameManager.currentInputMode == GameManager.InputMode.CONTROLLER:
		resume_button.grab_focus()
	
func Resume() -> void:
	panel.modulate.a = 0
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_button_pressed() -> void:
	Resume()

func _on_setting_button_pressed() -> void:
	pass # Replace with function body.

func _on_restart_button_pressed() -> void:
	Resume()
	#get_tree().reload_current_scene()
	SceneLoader.LoadScene(SceneLoader.mainLevelScene)
	GameManager.currentGameState = GameManager.GameState.RESTART


func _on_menu_button_pressed() -> void:
	Resume()
	SceneLoader.LoadScene(SceneLoader.mainMenuScene)


func _on_save_game_pressed() -> void:
	save_game_popup.show()
	


func _on_save_pressed() -> void:
	print("Game Saved")
	save_game_popup.hide()
	game_saved.show()
	await get_tree().create_timer(0.5).timeout
	game_saved.hide()
	
	
func _on_cancel_pressed() -> void:
	save_game_popup.hide()
