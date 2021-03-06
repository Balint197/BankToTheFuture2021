extends Control

func _ready():
	pass

func endOfDay():
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

