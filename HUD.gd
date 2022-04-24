extends CanvasLayer

onready var score_label_1 = $Score1
onready var score_label_2 = $Score2

func update_score1(new_score1):
	score_label_1.text = str(new_score1)

func update_score2(new_score2):
	score_label_2.text = str(new_score2)
