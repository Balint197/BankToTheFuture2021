extends Control


func _ready():
	pass


func _on_TextureButton_button_up():
	get_tree().change_scene("res://UI.tscn")
