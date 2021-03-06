extends Object

class_name Population

#population ratios
var population_ratios = {
	'POOR' : 0.32,
	'MIDDLE_LOW' : 0.21,
	'MIDDLE_HIGH' : 0.3,
	'RICH' : 0.18
}

#list of active customers
var active_customers = []

#list of passive customers
var passive_customers = []

#copy of marketing value from UI
var marketing

#total number of population
const POPULATION = 100

const DEBUG = true

#instances of customer classes for calculations
var customerTypes := {
	'POOR': Customer.new('POOR'),
	'MIDDLE_LOW': Customer.new('MIDDLE_LOW'),
	'MIDDLE_HIGH': Customer.new('MIDDLE_HIGH'),
	'RICH': Customer.new('RICH')
}

func get_amount_for_type(price, customer_type):
	if (customerTypes[customer_type].get_quantity(price) > 0):
		if DEBUG:
			print("Population is: {p}, ratio for type {t} is: {r}, reach is {m}, so there are {c} possible customers for this class".format({
				'p': POPULATION,
				't': customer_type,
				'r': population_ratios[customer_type],
				'm': get_population_reach(),
				'c': POPULATION * population_ratios[customer_type] * get_population_reach()
			}))
		return round(POPULATION * population_ratios[customer_type] * get_population_reach())
	else:
		return 0

#return a dictionary containing cusomer amounts for each category with a given price
func get_amount_for_all(price):
	var amount_for_types = {}
	for key in customerTypes:
		amount_for_types[key] = get_amount_for_type(price, key)
	return amount_for_types

#get reach from UI, normalize for [0,1]
func get_population_reach():
	#var marketing = get_tree().get_root().get_node("UI/ColorRect").reportValues()[2]
	return self.marketing/100.0

#initialize active customers array
#input: customers as a dictionary: 'name':amount
func init_active_customers(customers, price):
	if (!active_customers.empty()):
		delete_customer_array(true)
	for type in customers:
		var amount = get_amount_for_type(price, type)
		for i in range(0, amount):
			active_customers.push_back(Customer.new(type))
	return

#delete array objects individually to avoid memory leak
func delete_customer_array(active):
	if active:
		for i in range(0, active_customers.size()):
			active_customers[i].free()
		active_customers.clear()
	else:
		for i in range(0, passive_customers.size()):
			passive_customers[i].free()
		passive_customers.clear()

func update_marketing(new_marketing):
	self.marketing = new_marketing

#instantinate population with actual price
func _init(price, marketing_value):
	self.marketing = marketing_value
	var amounts = get_amount_for_all(price)
	init_active_customers(amounts, price)
	
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
