extends Node2D

var score : int = 0
var highscore : int = 0

@onready var score_text: Label = $CanvasLayer/UI/VBoxContainer/Score
@onready var high_score_text: Label = $CanvasLayer/UI/VBoxContainer/HighScore


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score = QuickSave.load_var("score", 0)
	highscore = QuickSave.load_var("highscore", 0)

	update_score_label()


func _on_increase_button_pressed() -> void:
	score += 1
	if score > highscore:
		highscore = score
		QuickSave.save_var("highscore", highscore)
	
	update_score_label()


func _on_decrease_button_pressed() -> void:
	score -= 1
	if score <= 0:
		score = 0
	
	update_score_label()

		
func update_score_label() -> void:
	score_text.text = str("Current Score: ", score)
	high_score_text.text = str("High Score: ", highscore)


func _on_save_button_pressed() -> void:
	QuickSave.save_var("score", score)


func _on_load_button_pressed() -> void:
	score = QuickSave.load_var("score", 0)
	update_score_label()
