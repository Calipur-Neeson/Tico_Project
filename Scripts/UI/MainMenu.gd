extends Node2D

@onready var new_game: Button = $CanvasLayer/MainMenu/VBoxContainer/NewGame
@onready var control: Control = $CanvasLayer/Control


func _ready() -> void:
	GameManager.OnInputModeChanged.connect(OnInputModeChanged)
	if GameManager.currentInputMode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif GameManager.currentInputMode == GameManager.InputMode.CONTROLLER:
		new_game.grab_focus()
	
func _on_new_game_pressed() -> void:
	SceneLoader.LoadScene(SceneLoader.mainLevelScene)

func _on_load_game_pressed() -> void:
	pass # Replace with function body.

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	pass # Replace with function body.


func OnInputModeChanged(mode: GameManager.InputMode) -> void:
	if mode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var button = control.get_focus_owner()
		button.release_focus()
		

	elif mode == GameManager.InputMode.CONTROLLER:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		new_game.grab_focus()
		
