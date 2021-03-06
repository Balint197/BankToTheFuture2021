extends Object

class_name Buffet

#--------------START OF CONSTANTS--------------------------------#
const MAX_NUM_OF_CUSTOMERS_TO_DISPLAY = 4
#--------------END OF CONSTANTS--------------------------------#
##################################################################################
#--------------START OF SIGNALS--------------------------------#
signal customerFinished
#--------------START OF SIGNALS--------------------------------#

#--------------START OF UI CONTROLLABLE VARIABLES--------------------------------#
var currentPrice := 0.0
var rentedSpace := 0.0
var marketing := 0.0
var chefs := 0.0
var rawMaterial := 0.0
#--------------END OF UI CONTROLLABLE VARIABLES----------------------------------#
##################################################################################
#--------------START OF DERIVED VARIABLES----------------------------------------#
var incomeDelta := 0.0

var dailyIncome :=0
var overallIncome :=0
#--------------END OF DERIVED VARIABLES------------------------------------------#
##################################################################################
#--------------START OF POPULATION-DERIVED VARIABLES-----------------------------#
var currentCustomerCount := 0 setget currentCustomerCountSet, currentCustomerCountGet
var customers := []
var reputation := 0.0

var numOfCustomersToDisplay := 0
#--------------END OF POPULATION-DERIVED VARIABLES-------------------------------#
##################################################################################

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func currentCustomerCountSet(customerCount):
	currentCustomerCount = customerCount
	numOfCustomersToDisplay = min(MAX_NUM_OF_CUSTOMERS_TO_DISPLAY, customerCount)
	
func currentCustomerCountGet():
	return currentCustomerCount

func addCustomer(customer: Customer):
	customers.push_back(customer)
	currentCustomerCountSet(currentCustomerCount + 1)
func removeCustomer():
	currentCustomerCountSet(currentCustomerCount - 1)
	return customers.pop_front()


