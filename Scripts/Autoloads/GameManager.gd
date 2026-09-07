extends Node

signal OnInputModeChanged(mode: InputMode)
signal OnGameRestart()

enum InputMode {
	KEYBOARD_MOUSE,
	CONTROLLER
}
enum GameState {
	MENU,
	PLAYING,
	PAUSE,
	OVER,
	RESTART
}

var currentInputMode := InputMode.KEYBOARD_MOUSE
var currentGameState := GameState.MENU
 
func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			SetInputMode(InputMode.KEYBOARD_MOUSE)
	elif event is InputEventMouseMotion:
		SetInputMode(InputMode.KEYBOARD_MOUSE)

	elif event is InputEventJoypadButton:
		if event.pressed:
			SetInputMode(InputMode.CONTROLLER)
	elif event is InputEventJoypadMotion:
		SetInputMode(InputMode.CONTROLLER)

func SetInputMode(mode: InputMode) -> void:
	if currentInputMode == mode:  
		return  
		
	currentInputMode = mode
	OnInputModeChanged.emit(currentInputMode)
