extends Node2D
#Main controller 

#---------------------------START OF LOADING CLASSES---------------------------------------------------------#
var buffetClass = preload("Buffet.gd")
#---------------------------END OF LOADING CLASSES-----------------------------------------------------------#

#---------------------------START OF ACCESSING NODES---------------------------------------------------------#
onready var UI = get_tree().get_root().get_node("UI")
onready var money = get_tree().get_root().get_node("UI/TextureRect/Label")
onready var priceSlider = get_tree().get_root().get_node("UI/ColorRect/HScrollBar")
onready var uiInterface = get_tree().get_root().get_node("UI/ColorRect")

onready var dayTimer = get_tree().get_root().get_node("UI/controller/DayTimer")
#---------------------------END OF ACCESSING NODES-----------------------------------------------------------#


#MAIN STATES of the application lifecycle
enum {START, DAY_INIT, DAY_RUNNING, DAY_ELAPSED, BETWEEN_DAYS}

#---------------------------START OF DECLARING VARIABLES-----------------------------------------------------#
#variable for storing the main state of the application lifecycle
var mainState = START

var start_to_dayInit := false

#variables for state transitions
var isDayElapsed := false

var myBuffet : Buffet = null

#---------------------------END OF DECLARING VARIABLES-------------------------------------------------------#

func _ready():
	#money.text = "120"

	pass


func _process(delta):
	#Handle UI states here
	
	pass

func collectUIData():
	var uiData = uiInterface.reportValues()
	print(myBuffet)
	if myBuffet != null:
		print("NOTNULL")
		#  [ár 0...100, bérelt hely 0...3, marketing 0...100, chef 1...4, alapanyag 0...4]
		print(uiData[0])
		myBuffet.currentPrice =  uiData[0]
		myBuffet.rentedSpace  =  uiData[1]
		myBuffet.marketing =     uiData[2]
		myBuffet.chefs =         uiData[3]
		myBuffet.rawMaterial =   uiData[4]

func doStateTransitions():
	var nextState = mainState
	print(mainState)
	#ONLY HANDLE STATE TRANSITIONS HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	match mainState:
		START:
			if start_to_dayInit:
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
			start_to_dayInit = true
		DAY_INIT:
			#start the day
			dayTimer.start()
			print(mainState)
		DAY_RUNNING:
			#collect ui data
			collectUIData()
			
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
