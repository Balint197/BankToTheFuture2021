extends Node2D

onready var numberOfCustomers = 5
var Customer = preload("res://characters.tscn") 

func _ready():
	var customer = Customer.instance()
	
	pass


