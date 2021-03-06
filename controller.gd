extends Node2D
#Main controller 

#---------------------------START OF LOADING CLASSES---------------------------------------------------------#
var buffetClass = preload("Buffet.gd")
#---------------------------END OF LOADING CLASSES-----------------------------------------------------------#

#---------------------------START OF ACCESSING NODES---------------------------------------------------------#
onready var UI = get_tree().get_root().get_node("UI")
onready var money = get_tree().get_root().get_node("UI/TextureRect/Label")
onready var priceSlider = get_tree().get_root().get_node("UI/ColorRect/HScrollBar")

onready var dayTimer = get_tree().get_root().get_node("UI/controller/DayTimer")
#---------------------------END OF ACCESSING NODES-----------------------------------------------------------#


#MAIN STATES of the application lifecycle
enum {START, DAY_INIT, DAY_RUNNING, DAY_ELAPSED, BETWEEN_DAYS}

#---------------------------START OF DECLARING VARIABLES-----------------------------------------------------#
#variable for storing the main state of the application lifecycle
var mainState = START

#variables for state transitions
var isDayElapsed := false

var myBuffet : Buffet

#---------------------------END OF DECLARING VARIABLES-------------------------------------------------------#

func test():
	priceSlider.value = 100
	var price = priceSlider.value
	#var marketing = get_tree().get_root().get_node("UI/ColorRect").reportValues()[2]
	var marketing = 20
	var population = Population.new(price, marketing, 10, 5)
	print('Population is done, there are {a} active customers and {p} passive ones.'.format({
		'a': population.active_customers.size(),
		'p': population.passive_customers.size()
		}))
	#print('Deleting active customers...')
	#population.call("delete_customer_array", true)
	#print('Deleting passive customers...')
	#population.call("delete_customer_array", false)
	print('After deleting, there are {a} active customers and {p} passive ones.'.format({
		'a': population.active_customers.size(),
		'p': population.passive_customers.size()
		}))
	#ennek így úgy kéne mennie hogy ahány vásárló van, annyian mennek be (mindenki egyszer)
	var totalcustomers = 0
	for i in range(0, 10*5*30):
		var customers = population.call("get_customers_tick")
		if(customers.size() > 0):
			#print("Tick {t} gave {c} customers".format({'t':i, 'c':customers.size()}))
			totalcustomers += customers.size()
	print('All customers in month: {c}'.format({'c':totalcustomers}))
	
	print("Original satisfaction is {s}".format({'s': population.active_customers[3].satisfaction}))
	var cust = population.active_customers[3]
	population.call('customer_shopped', cust, 3)
	print("New satisfaction is {s}".format({'s': population.active_customers[3].satisfaction}))
	
	var newprice = 80
	print("Changing price from {o} to {n}".format({'o': population.price, 'n': newprice}))
	print("Old reach:")
	var amounts = population.call('get_amount_for_all', price)
	for type in amounts:
		print("Type {t}\t amount {a}".format({'t': type, 'a':population.call('get_existing_amount_for_type', type)}))
	population.call('update_price', newprice)
	print("New reach:")
	var new_amounts = population.call('get_amount_for_all', newprice)
	for type in new_amounts:
		print("Type {t}\t amount {a}".format({'t': type, 'a':population.call('get_existing_amount_for_type', type)}))
		
	print('Population is done, there are {a} active customers and {p} passive ones.'.format({
		'a': population.active_customers.size(),
		'p': population.passive_customers.size()
		}))
			
	var newmarketing = 10
	print("Updating marketing from {o} to {n}".format({'o':population.marketing, 'n': newmarketing}))
	
	print("Old reach:")
	amounts = population.call('get_amount_for_all', population.price)
	for type in amounts:
		print("Type {t}\t amount {a}".format({'t': type, 'a':population.call('get_existing_amount_for_type', type)}))
	population.call('update_price', newprice)
	
	population.call("update_marketing", newmarketing)
	
	print("New reach:")
	new_amounts = population.call('get_amount_for_all', population.price)
	for type in new_amounts:
		print("Type {t}\t amount {a}".format({'t': type, 'a':population.call('get_existing_amount_for_type', type)}))
	
	print('Population is done, there are {a} active customers and {p} passive ones.'.format({
		'a': population.active_customers.size(),
		'p': population.passive_customers.size()
		}))
	

func _ready():
	#money.text = "120"
	test()
	pass


func _process(delta):
	#Handle UI states here

	pass



func doStateTransitions():
	var nextState = mainState
	print(mainState)
	#ONLY HANDLE STATE TRANSITIONS HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	match mainState:
		START:
			nextState = DAY_INIT
			print("nextState")
			print(nextState)
		DAY_INIT:
			nextState = DAY_RUNNING
			print("nextState")
			print(nextState)
		DAY_RUNNING:
			if isDayElapsed:
				nextState = DAY_ELAPSED
			print("nextState")
			print(nextState)
		DAY_ELAPSED:
			isDayElapsed = false
			print("nextState")
			print(nextState)
		BETWEEN_DAYS:
			print("nextState")
			print(nextState)
		_:
			nextState = START
			print("nextStateDEF")
			print(nextState)
			print("--nextStateDEF")
	#Update the main state
	mainState = nextState
	
#This function handles the application lifecycle
func _on_FrameUpdateTimer_timeout():
	#Update the states
	doStateTransitions()
	
	match mainState:
		START:
			print(mainState)
			#init the bufet
			myBuffet = buffetClass.new()
			
		DAY_INIT:
			dayTimer.start()
			print(mainState)
		DAY_RUNNING:
			print(mainState)
		DAY_ELAPSED:
			print(mainState)
		BETWEEN_DAYS:
			print(mainState)
		_:
			mainState = START
			print("def")
			print(mainState)
			print("--def")
			
	
#This function handles the day
func _on_DayTimer_timeout():
	print("Day elapsed")
	isDayElapsed = true
	pass # Replace with function body.
