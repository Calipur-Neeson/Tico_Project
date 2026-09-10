@tool
extends EditorPlugin

var panel : QuickSavePanel
const QUICKSAVE_PANEL = preload("res://addons/quicksave/ui/quicksave_panel.tscn")


func _enable_plugin() -> void:
	add_autoload_singleton("QuickSave", "res://addons/quicksave/quicksave_singleton.gd")


func _enter_tree() -> void:
	panel = QUICKSAVE_PANEL.instantiate() as QuickSavePanel
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, panel)


func _disable_plugin() -> void:
	remove_autoload_singleton("QuickSave")
	remove_control_from_docks(panel)
	panel.queue_free()
