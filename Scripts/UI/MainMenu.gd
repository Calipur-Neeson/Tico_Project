extends Control 
 
@onready var v_box_container: VBoxContainer = $CanvasLayer/MainMenu/VBoxContainer 
@onready var new_game: Button = $CanvasLayer/MainMenu/VBoxContainer/NewGame 

@onready var main_menu: Control = $CanvasLayer/MainMenu
@onready var option_menu: Control = $CanvasLayer/OptionMenu
@onready var audio_panel: Control = $"CanvasLayer/Audio Panel"
@onready var Display_panel: Control = $CanvasLayer/DisplayPanel
@onready var brightness_slider: HSlider = $CanvasLayer/DisplayPanel/VBoxContainer/HBoxContainer/HSlider
@onready var controls_panel: Control = $CanvasLayer/Controls_panel

@onready var resolution_option: OptionButton = $CanvasLayer/DisplayPanel/VBoxContainer/Resolution/OptionButton
@onready var hover_glow: Control = $CanvasLayer/MainMenu/VBoxContainer/NewGame/Hoverglow
@onready var brightness_overlay: ColorRect = get_node("/root/BrightnessManager/BrightnessOverlay")


func _ready() -> void: 
	main_menu.show()
	option_menu.hide()
	audio_panel.hide()
	var mode = DisplayServer.window_get_mode()
	var fullscreen = (
		mode == DisplayServer.WINDOW_MODE_FULLSCREEN
		or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	)
	$CanvasLayer/DisplayPanel/VBoxContainer/FullScreen_Controller.set_pressed_no_signal(fullscreen)

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
	option_menu.hide()
	controls_panel.show()


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

func _on_h_slider_value_changed(value: float) -> void:
	if brightness_overlay != null:
		brightness_overlay.material.set_shader_parameter("brightness", value)


func _on_new_game_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(hover_glow, "modulate:a", 1.0, 0.15)

func _on_back_pressed_controls() -> void:
	controls_panel.hide()
	option_menu.show()
	main_menu.hide()
