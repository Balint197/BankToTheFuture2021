extends Node2D

onready var UI = get_tree().get_root().get_node("UI")
onready var money = get_tree().get_root().get_node("UI/TextureRect/Label")
onready var priceSlider = get_tree().get_root().get_node("UI/ColorRect/HScrollBar")

func test():
	var customer := Customer.new('CUSTOMER_0')
	for price in range(80, 120, 5):
		print("M={m}, B={b}".format({'m': customer.gradient, 'b':customer.b}))
		var quant = customer.call("get_quantity", price)
		

func _ready():
	money.text = "120"
	test()
	pass


func _process(delta):
	print(priceSlider.value)
	pass
