@tool
extends HBoxContainer
class_name QuickSaveItem

@onready var key_data: LineEdit = $KeyData
@onready var value_data: LineEdit = $ValueData

func initialize(key : String, value : Variant) -> void:
	key_data.text = key
	value_data.text = str(value)
