extends Object

class_name Customer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
 


#parameters that describe the type of customer:
# middle price
# price dynamics
# min max quantity
var middle_price
var dynamics
var min_quantity
var max_quantity

#category of the customer
var category


#init function when class is instanced
func _init(category):
	self.middle_price = 100
	self.dynamics = 0.2
	self.min_quantity = 1
	self.max_quantity = 4
	self.category = category
	return

#function to get quantity for a given price
func get_quantity(price):
	return
	
#timeout for satisfaction
func degrade_satisfaction():
	return
	
#upgrade satisfaction after a good buy
func upgrade_satisfaction():
	return
	 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
