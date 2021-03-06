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

#total number of population
const POPULATION = 10000

const DEBUG = true

#instances of customer classes for calculations
var customerTypes := {
	'POOR': Customer.new('CUSTOMER_0'),
	'MIDDLE_LOW': Customer.new('CUSTOMER_1'),
	'MIDDLE_HIGH': Customer.new('CUSTOMER_2'),
	'RICH': Customer.new('CUSTOMER_3')
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
		return POPULATION * population_ratios[customer_type] * get_population_reach()
	else:
		return 0

#get reach from UI, normalize for [0,1]
func get_population_reach():
	var marketing = get_tree().get_root().get_node("UI/ColorRect").reportValues()['marketing']
	return marketing/100

#initialize active customers array
#input: customers as a dictionary: 'name':amount
func init_active_customers(customers, price):
	if (!active_customers.empty()):
		delete_customer_array(true)
	for type in customers:
		var amount = get_amount_for_type(price, key)
		for i in range(0, amount):
			active_customers.push_back(Customer.new(key))
	return

#delete array objects individually to avoid memory leak
func delete_customer_array(active):
	if active:
		for i in range(0, active_customers.count()):
			active_customers[i].free()
			active_customers.clear()
	else:
		for i in range(0, passive_customers.count()):
			passive_customers[i].free()
			passive_customers.clear()

func _init(price):
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
