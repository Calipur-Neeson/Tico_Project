extends Node2D

@export var playScene: StringName = &""
@onready var playButton: Button = $CanvasLayer/Panel/PlayButton

func _ready() -> void:
	playButton.pressed.connect(OnPlayPressed)

func OnPlayPressed() -> void:
	SceneLoader.LoadScene(playScene)
