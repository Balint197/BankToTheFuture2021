extends Object

class_name Customer

#parameters of customer
const DEBUG = true
const CUSTOMER_DEBUG = false
const DYNAMICS = 0.1
const MULT_MIN = 1
const MULT_MAX = 4
#satisfaction timeout is in days
const SATISFACTION_TIMEOUT = 30


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

#customer parameters
var CUSTOMER_0 = {
	'q_min': 1,
	'q_max': 4,
	'p_0': 100,
	'satisfaction': 1
}
var CUSTOMER_1 = {
	'q_min': 1,
	'q_max': 4,
	'p_0': 100,
	'satisfaction': 1
}
var CUSTOMER_2 = {
	'q_min': 1,
	'q_max': 4,
	'p_0': 100,
	'satisfaction': 1
}
var CUSTOMER_3 = {
	'q_min': 1,
	'q_max': 4,
	'p_0': 100,
	'satisfaction': 1
}

#array to hold customer categories, this maps string names with categories
var CUSTOMER_CATEGORIES = {
	'POOR': CUSTOMER_0,
	'MIDDLE_LOW': CUSTOMER_1,
	'MIDDLE_HIGH': CUSTOMER_2,
	'RICH': CUSTOMER_3
}

#init function when class is instanced
func _init(customer_category):
	self.middle_price = CUSTOMER_CATEGORIES[customer_category]['p_0']
	self.dynamics = self.middle_price*DYNAMICS
	self.min_quantity = CUSTOMER_CATEGORIES[customer_category]['q_min']
	self.max_quantity = CUSTOMER_CATEGORIES[customer_category]['q_max']
	self.satisfaction = CUSTOMER_CATEGORIES[customer_category]['satisfaction']
	self.category = customer_category
	self.gradient = -2*self.dynamics/(self.max_quantity-self.min_quantity)
	self.multiplyer = randi() % (MULT_MAX - MULT_MIN) + MULT_MIN
	self.b = self.middle_price + self.dynamics - self.min_quantity * self.gradient
	
	if CUSTOMER_DEBUG:
		print('Customer of category {c} created with multiplyer of {m}'.format({'c':self.category, 'm':self.multiplyer}))
	
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
	q = round(q) * self.multiplyer
	if DEBUG:
		print('Customer is buying {q} ice cream for {p} each'.format({'q':q, 'p':price}))
	return q
	
#timeout for satisfaction
func degrade_satisfaction(degdaration_per_tick):
	self.satisfaction *= degdaration_per_tick
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
