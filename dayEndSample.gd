extends Control

func _ready():
	$daySummary.text = "Vagyonod a nap végén: " + String(Globalis.allMoney)

func goodAnswer():
	print("ok")
	$ColorRect.color = Color(0.22, 0.6, 0.21)
	# add money/sth
	$jo.visible = true
	Globalis.allMoney += 300

	$Timer.start()
	hideUI()
	
func wrongAnswer():
	$ColorRect.color = Color(0.6, 0.24, 0.21)
	$rossz.visible = true
	Globalis.allMoney -= 100
	$Timer.start()
	hideUI()
	
func hideUI():
	$GridContainer.visible = false
	$iras.visible = false
	$daySummary.visible = false
	$kerdes.visible = false


func _on_Timer_timeout():
	get_tree().change_scene("res://UI.tscn") # go to gameView UI


func _on_good_button_up():
	goodAnswer()


func _on_bad1_button_up():
	wrongAnswer()


func _on_bad2_button_up():
	wrongAnswer()


func _on_bad3_button_up():
	wrongAnswer()
