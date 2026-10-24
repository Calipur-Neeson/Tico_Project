class_name PlayerHUD
extends Panel

@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var sprite_2d: Sprite2D = $Sprite2D

signal OnSave

func _ready() -> void:
	sprite_2d.hide()
	OnSave.connect(ShowSaveIndicator)


func ShowSaveIndicator() -> void:
	sprite_2d.show()
	sprite_2d.rotation = 0.0
	
	var tween = create_tween()
	tween.tween_property(sprite_2d, "rotation", TAU, 2.0)
	tween.tween_callback(sprite_2d.hide)
