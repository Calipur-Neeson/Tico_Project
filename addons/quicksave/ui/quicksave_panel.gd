@tool
extends Control
class_name QuickSavePanel

const QUICK_SAVE_ITEM_PREFABR = preload("res://addons/quicksave/ui/quicksave_item_prefab.tscn")

@onready var quick_save_item_container: VBoxContainer = $ScrollContainer/QuickSaveItemContainer

func _ready() -> void:
	EditorInterface.edit_node(self)
	reload_data()


func reload_data() -> void:
	QuickSave.reload_data()
	for item in quick_save_item_container.get_children():
		item.queue_free()
	
	for data_key in QuickSave.get_save_data():
		var item : QuickSaveItem = QUICK_SAVE_ITEM_PREFABR.instantiate() as QuickSaveItem
		quick_save_item_container.add_child(item)
		
		item.initialize(data_key, QuickSave.load_var(data_key))


func _on_clear_button_pressed() -> void:
	QuickSave.clear_all_data()
	reload_data()


func _on_refresh_button_pressed() -> void:
	reload_data()
