extends Control

@onready var v_box_container: VBoxContainer = $CanvasLayer/MainMenu/VBoxContainer

@onready var new_game: Button = $CanvasLayer/MainMenu/VBoxContainer/NewGame


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
	get_tree().quit()


func OnInputModeChanged(mode: GameManager.InputMode) -> void:
	if mode == GameManager.InputMode.KEYBOARD_MOUSE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_viewport().gui_release_focus()
		

	elif mode == GameManager.InputMode.CONTROLLER:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		new_game.grab_focus.call_deferred()
		
