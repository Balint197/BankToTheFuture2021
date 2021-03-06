extends Object

class_name Customer

#parameters of customer
const DEBUG = true
const DYNAMICS = 0.1
const MULT_MIN = 1
const MULT_MAX = 4
const SATISFACTION_DEGRADATION = 0.2


#parameters that describe the type of customer:
# middle price
# price dynamics
# min max quantity
# gradient of p-q function
# multiplyer for children/family
# satisfaction
var middle_price
var dynamics
var min_quantity
var max_quantity
var gradient
var multiplyer
var satisfaction

#category of the customer
var category

#buffer variable for storing function parameter from p=mq+b
var b

#init function when class is instanced
func _init():
	self.middle_price = 90
	self.dynamics = self.middle_price*DYNAMICS
	self.min_quantity = 3
	self.max_quantity = 5
	self.category = "categorycsöves2"
	self.gradient = -2*self.dynamics/(self.max_quantity-self.min_quantity)
	self.multiplyer = randi() % (MULT_MAX - MULT_MIN) + MULT_MIN
	self.b = self.middle_price + self.dynamics - self.min_quantity * self.gradient
	if DEBUG:
		print('Customer created with multiplyer of {m}'.format({'m':self.multiplyer}))
	
	return

#function to get quantity for a given price
# input: price
# return: -1 if customer doesn't come in, buyed quantity else
func get_quantity(price):
	#if price is not in the range, return -1
	if((price < self.middle_price-self.dynamics) || (price > self.middle_price+self.dynamics)):
		if DEBUG:
			print('Customer doesn\'t buy anything because price {p} is out of range'.format({'p':price}))
		return -1
	
	var q = 1/self.gradient*price - self.b/self.gradient
	q = round(q)
	if DEBUG:
		print('Customer is buying {q} ice cream for {p} each'.format({'q':q, 'p':price}))
	return q
	
#timeout for satisfaction
func degrade_satisfaction():
	self.satisfaction *= SATISFACTION_DEGRADATION
	return
	
#upgrade satisfaction after a good buy
func upgrade_satisfaction(factor):
	self.satisfaction *= factor
	return
	 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
