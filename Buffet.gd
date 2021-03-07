extends Object

class_name Buffet

var RENT_OPTIONS = [
	{'price': 0, 'satisfaction': 0},
	{'price': 500, 'satisfaction': 0.1},
	{'price': 1000, 'satisfaction': 0.4},
	{'price': 2000, 'satisfaction': 0.5}
]

var CHEF_OPTIONS = [
	{'price': 500, 'satisfaction': 0},
	{'price': 1000, 'satisfaction': 0.1},
	{'price': 1500, 'satisfaction': 0.3},
	{'price': 2000, 'satisfaction': 0.5},
]

#100% reach costs this amount
const MARKETING_PRICE = 1000

#one material option caused satisfaction
const RAW_MATERIAL_SATISFACTION = 0.1



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
var currentCustomerCount := 0 
var customers := []
var reputation := 0.0


#--------------END OF POPULATION-DERIVED VARIABLES-------------------------------#
##################################################################################

func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	


func addCustomer(customer: Customer):
	customers.push_back(customer)
	currentCustomerCount += 1
func removeCustomer():
	if currentCustomerCount>0:
		currentCustomerCount -=1
	return customers.pop_front()
	
func payBills():
	var bills = 0
	bills += RENT_OPTIONS[int(self.rentedSpace)]['price']
	bills += CHEF_OPTIONS[int(self.chefs)-1]['price']
	bills += self.marketing/100.0 * MARKETING_PRICE
	print("Paying bills: {r} rent, {c} chef, {m} marketing".format({
		'r': RENT_OPTIONS[int(self.rentedSpace)]['price'],
		'c': CHEF_OPTIONS[int(self.chefs)-1]['price'],
		'm': self.marketing/100.0 * MARKETING_PRICE
		}))	
	self.overallIncome -= bills
	return bills
	
func getReputation():
	var reputation = 1
	reputation += RENT_OPTIONS[int(self.rentedSpace)]['satisfaction']
	reputation += CHEF_OPTIONS[int(self.chefs)-1]['satisfaction']
	reputation += self.rawMaterial * RAW_MATERIAL_SATISFACTION
	print("Calculating reputation: {r} from rent, {c} from chef, {m} from material, all together {s}".format(
		{
			'r': RENT_OPTIONS[int(self.rentedSpace)]['satisfaction'],
			'c': CHEF_OPTIONS[int(self.chefs)-1]['satisfaction'],
			'm': self.rawMaterial * RAW_MATERIAL_SATISFACTION,
			's': reputation
		}
	))
	return reputation

func getPrice(what):
	match what:
		'chef':
			return CHEF_OPTIONS[int(self.chefs)-1]['price']
		'rent':
			return RENT_OPTIONS[int(self.rentedSpace)]['price']
		'marketing':
			return self.marketing/100.0 * MARKETING_PRICE
		'material':
			return self.rawMaterial
		_:
			return -1


