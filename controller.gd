extends Node2D
#Main controller 
const DEBUG = true

#---------------------------START OF LOADING CLASSES---------------------------------------------------------#
var buffetClass = preload("Buffet.gd")
var customerClass = preload("Customer.gd")
#---------------------------END OF LOADING CLASSES-----------------------------------------------------------#

#---------------------------START OF ACCESSING NODES---------------------------------------------------------#
onready var UI = get_tree().get_root().get_node("UI")
onready var money = get_tree().get_root().get_node("UI/TextureRect/Label")
onready var priceSlider = get_tree().get_root().get_node("UI/ColorRect/HScrollBar")
onready var uiInterface = get_tree().get_root().get_node("UI/ColorRect")

onready var dayTimer = get_tree().get_root().get_node("UI/controller/DayTimer")
#---------------------------END OF ACCESSING NODES-----------------------------------------------------------#

signal customerComesIn
signal firstCustomerComesIn
signal nextCustomerToDesk
signal startInteraction
signal showSpecial
signal customeShallPay
signal waitForChange
signal customerFinished
signal dayElapsed


#MAIN STATES of the application lifecycle
enum {START, DAY_INIT, DAY_RUNNING, DAY_ELAPSED, BETWEEN_DAYS}

#MAIN STATES of the customer interaction
enum {NO_CUSTOMER, INTERACTION_START, CHECK_SPECIAL, CUSTOMER_FINISHING, CUSTOMER_APPROACHING,
	  PAYING, WAITING_FOR_CHANGE,}
var d = {NO_CUSTOMER:"NO_CUSTOMER", INTERACTION_START:"INTERACTION_START", CHECK_SPECIAL:"CHECK_SPECIAL", 
	 CUSTOMER_FINISHING:"CUSTOMER_FINISHING", CUSTOMER_APPROACHING:"CUSTOMER_APPROACHING",
	  PAYING:"PAYING", WAITING_FOR_CHANGE:"WAITING_FOR_CHANGE"}

#---------------------------START OF DECLARING VARIABLES-----------------------------------------------------#
#variable for storing the main state of the application lifecycle
var mainState = START

var interactionState := NO_CUSTOMER

var firstCustomerCameIn   := false
var nextCustomerCanComeToDesk   := false
var nextCustomerArrivedToDesk   := false
var startOfInteractionDone      := false
var noSpecial                   := false
var specialsDone                := false
var hasPayed                    := false
var changeClaimed               := false
var hasGoneOut                  := false
var noCard                      := false


var start_to_dayInit := false

#variables for state transitions
var isDayElapsed := false

var myBuffet : Buffet = null

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

func collectUIData():
	var uiData = uiInterface.reportValues()
	if myBuffet != null:
		print("NOTNULL")
		#  [ár 0...100, bérelt hely 0...3, marketing 0...100, chef 1...4, alapanyag 0...4]
		print(uiData[0])
		myBuffet.currentPrice =  uiData[0]
		myBuffet.rentedSpace  =  uiData[1]
		myBuffet.marketing =     uiData[2]
		myBuffet.chefs =         uiData[3]
		myBuffet.rawMaterial =   uiData[4]


	
#This function handles the application lifecycle
func _on_FrameUpdateTimer_timeout():
	
	var nextState = mainState
	
	match mainState:
		START:
			print(mainState)
			#init the bufet
			myBuffet = buffetClass.new()
			start_to_dayInit = true
			if start_to_dayInit:
				nextState = DAY_INIT
		DAY_INIT:
			#start the day
			dayTimer.start()
			print(mainState)
			nextState = DAY_RUNNING
			if DEBUG:
				myBuffet.addCustomer(customerClass.new('POOR'))
				nextCustomerCanComeToDesk = true
				myBuffet.addCustomer(customerClass.new('POOR'))
				myBuffet.addCustomer(customerClass.new('POOR'))
		DAY_RUNNING:
			#collect ui data
			collectUIData()
			#run the customer state machine
			customerStateMachine()
			if isDayElapsed:
				nextState = DAY_ELAPSED
			print(mainState)
		DAY_ELAPSED:
			isDayElapsed = false
			nextState = BETWEEN_DAYS
			print(mainState)
		BETWEEN_DAYS:
			print(mainState)
		_:
			mainState = START
			print("def")
			print(mainState)
			print("--def")
	#Update the main state
	mainState = nextState
			
func customerStateMachine():
	#{NO_CUSTOMER, INTERACTION_START, CHECK_SPECIAL, CUSTOMER_FINISHING, CUSTOMER_APPROACHING,
	  #PAYING, WAITING_FOR_CHANGE,}
	var nextState = interactionState
	print(d[interactionState])
	match interactionState:
		NO_CUSTOMER:
#			if firstCustomerCameIn:
#				firstCustomerCameIn = false
#				emit_signal("firstCustomerComesIn")#, myBuffet.numOfCustomersToDisplay)
			if nextCustomerCanComeToDesk:
				nextState = CUSTOMER_APPROACHING 
				nextCustomerCanComeToDesk = false
				emit_signal("nextCustomerToDesk")
		INTERACTION_START:
			if startOfInteractionDone:
				startOfInteractionDone = false
				nextState = CHECK_SPECIAL
				emit_signal("showSpecial")
		CHECK_SPECIAL:
			if specialsDone || noSpecial:
				specialsDone = false
				noSpecial = false
				var customer = myBuffet.customers[0]
				var quantity = customer.get_quantity(myBuffet.currentPrice)
				if quantity >= 0:
					nextState = PAYING
					emit_signal("customerShallPay")#,quantity * myBuffet.currentPrice)
				else:
					nextState = CUSTOMER_FINISHING
					emit_signal("customerFinished")
		CUSTOMER_FINISHING:
			if hasGoneOut:
				var customer = myBuffet.removeCustomer()
				hasGoneOut = false
				if myBuffet.currentCustomerCount == 0:
					nextState = NO_CUSTOMER
				else:
					nextState = CUSTOMER_APPROACHING
					emit_signal("nextCustomerToDesk")
		CUSTOMER_APPROACHING:
			if nextCustomerArrivedToDesk:
				nextCustomerArrivedToDesk = false
				nextState = PAYING
				emit_signal("customeShallPay")
				#emit_signal("StartInteraction")
		PAYING:
			
			if hasPayed:
				hasPayed = false
				#nextState = WAITING_FOR_CHANGE
				nextState = CUSTOMER_FINISHING
				emit_signal("customerFinished")
				#emit_signal("waitForChange")
		WAITING_FOR_CHANGE:
			if changeClaimed:
				changeClaimed = false
				nextState = CUSTOMER_FINISHING
				emit_signal("customerFinished")
		_:
			nextState = NO_CUSTOMER
			
	interactionState = nextState


#This function handles the day
func _on_DayTimer_timeout():
	print("Day elapsed")
	isDayElapsed = true
	emit_signal("dayElapsed")


func _on_gameUI_customerDone():
	pass # UI-os


func _on_gameUI_changeClaimed():
	changeClaimed = true


func _on_gameUI_firstCustomerCameIn():
	firstCustomerCameIn = true


func _on_gameUI_hasGoneOut():
	hasGoneOut = true


func _on_gameUI_hasPayed():
	hasPayed = true


func _on_gameUI_nextCustomerArrivedToDesk():
	nextCustomerArrivedToDesk = true


func _on_gameUI_nextCustomerCanComeToDesk():
	nextCustomerCanComeToDesk = true


func _on_gameUI_noCard():
	noCard = true


func _on_gameUI_noSpecial():
	noSpecial = true


func _on_gameUI_specialsDone():
	specialsDone = true


func _on_gameUI_startOfInteractionDone():
	startOfInteractionDone = true
