extends Control

@onready var audio_name_lbl: Label = $HBoxContainer/Audio_Name_lbl as Label
@onready var h_slider: HSlider = $HBoxContainer/HSlider as HSlider
@onready var audio_num_lbl: Label = $HBoxContainer/Audio_Num_lbl as Label

@export_enum("Master", "Music", "Sfx") var bus_name : String 

var bus_index : int = 0

func _ready():
	h_slider.value_changed.connect(on_value_changed)


func set_name_label_text() -> void
label.text = Str(bus_name) + "Volume"
func on_value_changed(value : float) -> void:
	
