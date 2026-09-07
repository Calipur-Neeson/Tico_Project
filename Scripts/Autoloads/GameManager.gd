extends Node

signal input_mode_changed(mode: InputMode)

enum InputMode {
	KEYBOARD_MOUSE,
	CONTROLLER
}

var current_mode := InputMode.KEYBOARD_MOUSE

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
	if current_mode == mode:  
		return  
		
	current_mode = mode
	input_mode_changed.emit(current_mode)
