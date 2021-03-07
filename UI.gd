extends Control

func _ready():
	pass

func endOfDay():
	Globalis.daysPassed += 1
	if Globalis.daysPassed == 4:
		get_tree().change_scene("res://failState.tscn")
	else:
		var x = randi() % 3
		match x:
			0:
				get_tree().change_scene("res://dayEnd1.tscn")
			1:
				get_tree().change_scene("res://dayEnd2.tscn")
			2:
				get_tree().change_scene("res://dayEnd3.tscn")

func _on_controller_dayElapsed():
	endOfDay()



func _on_controller_firstCustomerComesIn():
	pass # Replace with function body.
