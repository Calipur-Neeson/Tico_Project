extends HBoxContainer

@onready var language_option: OptionButton = $OptionButton


func _ready() -> void:
	language_option.clear()

	language_option.add_item("English")
	language_option.add_item("Suomi")
	language_option.add_item("中文")
	language_option.add_item("日本語")
	
	language_option.item_selected.connect(_on_language_option_item_selected)

	if QuickSave.has_var("LanguageIndex"):
		var index : int = QuickSave.load_var("LanguageIndex")
		language_option.select(index)
		_on_language_option_item_selected(index)
	else:
		language_option.select(_get_locale_index(TranslationServer.get_locale()))


 
func _on_language_option_item_selected(index: int) -> void:
	match index:
		0:
			TranslationServer.set_locale("en")
		1:
			TranslationServer.set_locale("fi")
		2:
			TranslationServer.set_locale("zh")
		3:
			TranslationServer.set_locale("ja")
	
	QuickSave.save_var("LanguageIndex", index)


func _get_locale_index(locale: String) -> int:
	match locale.substr(0, 2):
		"fi":
			return 1
		"zh":
			return 2
		"ja":
			return 3
		_:
			return 0
