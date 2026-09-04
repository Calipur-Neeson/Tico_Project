extends CanvasLayer

var isPaused: bool = false
@export var menuScene: StringName = &""

@onready var panel: Panel = $Panel


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
	
func Resume() -> void:
	panel.modulate.a = 0
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	Resume()

func _on_setting_button_pressed() -> void:
	pass # Replace with function body.

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	Resume()
	SceneLoader.LoadScene(menuScene)
