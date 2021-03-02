extends Node2D

onready var UI = get_tree().get_root().get_node("UI")
onready var money = get_tree().get_root().get_node("UI/TextureRect/Label")
onready var priceSlider = get_tree().get_root().get_node("UI/ColorRect/HScrollBar")

func _ready():
	money.text = "120"

	pass


func _process(delta):
	print(priceSlider.value)
	pass
