extends Node2D

@onready var play_button: Button = $CanvasLayer/Panel/PanelContainer/VBoxContainer/PlayButton
@onready var setting_button: Button = $CanvasLayer/Panel/PanelContainer/VBoxContainer/SettingButton
@onready var exit_button: Button = $CanvasLayer/Panel/PanelContainer/VBoxContainer/ExitButton


func _ready() -> void:
	GameManager.OnInputModeChanged.connect(OnInputModeChanged)
	if GameManager.currentInputMode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif GameManager.currentInputMode == GameManager.InputMode.CONTROLLER:
		play_button.grab_focus()
	

func _on_play_button_pressed() -> void:
	SceneLoader.LoadScene(SceneLoader.mainLevelScene)

func _on_setting_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	pass # Replace with function body.

func OnInputModeChanged(mode: GameManager.InputMode) -> void:
	if mode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		play_button.release_focus()
		setting_button.release_focus()
		exit_button.release_focus()

	elif mode == GameManager.InputMode.CONTROLLER:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		play_button.grab_focus()
		
