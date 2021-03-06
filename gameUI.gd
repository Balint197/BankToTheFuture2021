extends Node2D

onready var numberOfCustomers = 5
var Customer = preload("res://characters.tscn") 
var characters_array = []
var ordering = 0
var buffer = 0
var maxZ = 0
#path: 1->0

var firstCustomer = 0

signal customerDone
signal firstCustomerCameIn
signal nextCustomerCanComeToDesk
signal nextCustomerArrivedToDesk
signal startOfInteractionDone
signal noSpecial
signal specialsDone
signal hasPayed
signal changeClaimed
signal hasGoneOut
signal noCard


func _ready():
#	var customer = Customer.instance()
#	$Path2D.add_child(customer)
#	customer.connect("ordering", self, "handleOrder")
#	customer.get_node("AnimationPlayer").play("walk_forward")

	walkForward()
	pass

func newCustomer():
	if ordering == 0:

		characters_array = $Path2D.get_children()
		var maxOffset = 0
		var maxZ = 0
		for i in characters_array:
			if i.unit_offset > maxOffset:
				maxOffset = i.unit_offset
			if i.z_index < maxZ:
				maxZ = i.z_index

		if maxOffset < 0.9:
			if firstCustomer == 0:
				firstCustomer = 1
				emit_signal("nextCustomerCanComeToDesk")
			var customer = Customer.instance()
			$Path2D.add_child(customer)
			customer.connect("ordering", self, "handleOrder")
			customer.get_node("AnimationPlayer").play("walk_forward")
			customer.z_index = maxZ - 1
			
			
	if ordering == 1:
		buffer += 1


func walkForward():
	characters_array = $Path2D.get_children()
	for i in characters_array:
		i.get_node("AnimationPlayer").play("walk_forward")

func handleOrder():
	print("ordering")
	ordering = 1
	characters_array = $Path2D.get_children()
	for i in characters_array:
		i.get_node("AnimationPlayer").stop(false)
	startMiniGame()

func startMiniGame():
	$Button.visible = true
	$Button.disabled = false
	emit_signal("nextCustomerArrivedToDesk")
	emit_signal("nextCustomerCanComeToDesk")
	
func _on_Button_pressed():
	$Button.visible = false
	$Button.disabled = true
	endMiniGame()
	
func endMiniGame():
	ordering = 0
	emit_signal("customerDone")
	emit_signal("nextCustomerCanComeToDesk")
	emit_signal("hasPayed")
	if buffer > 0:
		newCustomer()
		buffer -= 1
	characters_array = $Path2D.get_children()
	var leaving = characters_array[0]
	$Path2D.remove_child(leaving) 
	add_child(leaving)
	leaving.get_node("AnimationPlayer").play("walkOut")
	for i in characters_array:
		i.get_node("AnimationPlayer").play()


func _on_Button2_pressed():
	newCustomer()


func _on_controller_newCustomer():
	pass # Replace with function body.


func _on_controller_firstCustomerComesIn():
	newCustomer()


func _on_controller_nextCustomerToDesk():
	newCustomer()
	# emit_signal("nextCustomerArrivedToDesk")


func _on_controller_customeShallPay():
	pass


func _on_controller_customerComesIn():
	emit_signal("nextCustomerCanComeToDesk")


func _on_controller_customerFinished():
	emit_signal("hasGoneOut")


func _on_controller_dayElapsed():
	pass # Replace with function body.


func _on_controller_showSpecial():
	emit_signal("specialsDone")
	# emit_signal("noSpecial")
	# @TODO későbbi bővítés, pl kártya


func _on_controller_startInteraction():
	emit_signal("startOfInteractionDone")


func _on_controller_waitForChange():
	emit_signal("changeClaimed")
