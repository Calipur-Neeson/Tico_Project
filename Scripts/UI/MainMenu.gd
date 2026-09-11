extends Control 
 
@onready var v_box_container: VBoxContainer = $CanvasLayer/MainMenu/VBoxContainer 
@onready var new_game: Button = $CanvasLayer/MainMenu/VBoxContainer/NewGame 

@onready var main_menu: Control = $CanvasLayer/MainMenu
@onready var option_menu: Control = $CanvasLayer/OptionMenu
@onready var audio_panel: Control = $"CanvasLayer/Audio Panel"
@onready var Display_panel: Control = $CanvasLayer/DisplayPanel

@onready var resolution_option: OptionButton = $CanvasLayer/DisplayPanel/VBoxContainer/Resolution/OptionButton

func _ready() -> void: 
	main_menu.show()
	option_menu.hide()
	audio_panel.hide()

	GameManager.OnInputModeChanged.connect(OnInputModeChanged) 
	
	if GameManager.currentInputMode == GameManager.InputMode.KEYBOARD_MOUSE: 
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
	elif GameManager.currentInputMode == GameManager.InputMode.CONTROLLER: 
		new_game.grab_focus() 
		
	resolution_option.clear()
	resolution_option.add_item("1920x1080")
	resolution_option.add_item("1600x900")
	resolution_option.add_item("1280x720")
	 
func _on_new_game_pressed() -> void: 
	SceneLoader.LoadScene(SceneLoader.mainLevelScene) 
 
func _on_load_game_pressed() -> void: 
	pass # Replace with function body. 
 
func _on_options_pressed() -> void: 
	main_menu.hide()
	option_menu.show()


func _on_exit_pressed() -> void: 
	get_tree().quit() 
 
func OnInputModeChanged(mode: GameManager.InputMode) -> void: 
	if mode == GameManager.InputMode.KEYBOARD_MOUSE: 
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 
		get_viewport().gui_release_focus() 
		 
 
	elif mode == GameManager.InputMode.CONTROLLER: 
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN 
		new_game.grab_focus.call_deferred()


func _on_full_screen_controller_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer. window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer. window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_audio_pressed() -> void:
	option_menu.hide()
	audio_panel.show()


func _on_controls_pressed() -> void:
	pass # Replace with function body.


func _on_display_pressed() -> void:
	option_menu.hide()
	Display_panel.show()


func _on_back_pressed() -> void:
	main_menu.show()
	option_menu.hide()


func _on_back_audio_pressed() -> void:
	main_menu.hide()
	audio_panel.hide()
	option_menu.show()


func _on_back_Display_pressed() -> void:
	main_menu.hide()
	Display_panel.hide()
	option_menu.show()
	
	
func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: get_window().size = Vector2i(1920, 1080)
		1: get_window().size = Vector2i(1600, 900)
		2: get_window().size = Vector2i(1280, 720)
