@tool
extends Node

const SAVE_LOCATION : String = "user://quicksave_data.qsav"

signal on_data_change

var _save_data : Dictionary[String, Variant] = {}


## Save variable to the save data using key
func save_var(key: String, value: Variant) -> void:
	var file : FileAccess = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	_save_data[key] = value
	var success : bool = file.store_var(_save_data)
	if !success:
		printerr("[ERROR] Cannot store ", key, " with value ", value, "!")
	file.close()
	
	on_data_change.emit()


## Load variable from the save data using key
func load_var(key: String, default_value : Variant = null) -> Variant:
	reload_data()
	
	if _save_data.has(key):
		return _save_data[key]
	else:
		save_var(key, default_value)
		return default_value


## Reload the data manually if something has not been saved
func reload_data() -> void:
	var file : FileAccess
	if not FileAccess.file_exists(SAVE_LOCATION):
		file = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
		var success : bool = file.store_var(_save_data)
		if !success:
			printerr("[ERROR] Cannot reload data!")
		file.close()
		
	file = FileAccess.open(SAVE_LOCATION, FileAccess.READ)
	_save_data = file.get_var()
	file.close()


func clear_all_data() -> void:
	_save_data.clear()
	if not FileAccess.file_exists(SAVE_LOCATION):
		return
	
	var file : FileAccess = FileAccess.open(SAVE_LOCATION, FileAccess.WRITE)
	var success : bool = file.store_var(_save_data)
	if !success:
		printerr("[ERROR] Cannot clear data!")
	file.close()
	
	on_data_change.emit()


func get_save_data() -> Dictionary[String, Variant]:
	return _save_data
