extends CanvasLayer

var isPaused: bool = false

@onready var panel: Panel = $Panel
@onready var resume_button: Button = $Panel/PanelContainer/VBoxContainer/ResumeButton
@onready var panel_container: PanelContainer =  $Panel/PanelContainer
@onready var save_game_popup: Control = $Panel/SaveGame_popup
@onready var game_saved: Label = $"Panel/Game Saved"
@onready var option_menu: Control = $Panel/OptionMenu
@onready var audio_panel: Control = $"Panel/Audio Panel"
@onready var display_panel: Control = $Panel/DisplayPanel
@onready var controls_panel: Control = $Panel/Controls_panel




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
	option_menu.show()
	panel_container.hide()

func _on_restart_button_pressed() -> void:
	Resume()
	#get_tree().reload_current_scene()
	SceneLoader.LoadScene(SceneLoader.mainLevelScene)
	GameManager.currentGameState = GameManager.GameState.RESTART


func _on_menu_button_pressed() -> void:
	Resume()
	SceneLoader.LoadScene(SceneLoader.mainMenuScene)
	option_menu.show()


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
	
	#Options
	


func _on_back_pressed() -> void:
	option_menu.hide()
	panel_container.show()


func _on_audio_pressed() -> void:
	option_menu.hide()
	audio_panel.show()
	
func _on_controls_pressed() -> void:
	option_menu.hide()
	controls_panel.show()
	
func _on_display_pressed() -> void:
	option_menu.hide()
	display_panel.show()


func _on_back_pressed_audio() -> void:
	audio_panel.hide()
	option_menu.show()
	
func _on_back_pressed_display() -> void:
	display_panel.hide()
	option_menu.show()


func _on_back_pressed_controls() -> void:
	controls_panel.hide()
	option_menu.show()

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: get_window().size = Vector2i(1920, 1080)
		1: get_window().size = Vector2i(1600, 900)
		2: get_window().size = Vector2i(1280, 720)


func _on_full_screen_controller_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
