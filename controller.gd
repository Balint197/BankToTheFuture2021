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

func _ready():
	#money.text = "120"

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
