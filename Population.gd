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

#copy of ticks per day from controller
var ticks_per_day

#total number of population
const POPULATION = 1000
#maximal satisfaction
const MAX_SATISFACTION = 4
#minimal satisfaction
const MIN_SATISFACTION = 0.5
#time in days in which the satisfaction halves
const SATISFACTION_FREQUENCY = 30
var satisfaction_degradation_per_tick

const DEBUG = true

#instances of customer classes for calculations
var customerTypes := {
	'POOR': Customer.new('POOR'),
	'MIDDLE_LOW': Customer.new('MIDDLE_LOW'),
	'MIDDLE_HIGH': Customer.new('MIDDLE_HIGH'),
	'RICH': Customer.new('RICH')
}

#copy customer object
func copy_customer(old_customer):
	var new_customer := Customer.new(old_customer.category)
	new_customer.middle_price = old_customer.middle_price
	new_customer.dynamics = old_customer.dynamics
	new_customer.min_quantity = old_customer.min_quantity
	new_customer.max_quantity = old_customer.max_quantity
	new_customer.satisfaction = old_customer.satisfaction
	new_customer.category = old_customer.category
	new_customer.gradient = old_customer.gradient
	new_customer.multiplyer = old_customer.multiplyer
	new_customer.b = old_customer.b
	return new_customer

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

#get existing amount for type
func get_existing_amount_for_type(type):
	var count = 0
	for i in range(0, active_customers.size()):
		if(active_customers[i].category == type):
			count += 1
	return count

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
	var old_amounts = get_amount_for_all(self.price)
	self.marketing = new_marketing
	var new_amounts = get_amount_for_all(self.price)
	#if the reach is bigger, add the difference, if lower, delete some customers
	for type in new_amounts:
		var difference = new_amounts[type] - old_amounts[type]
		if(difference > 0):
			for i in range(0, difference):
				active_customers.push_back(Customer.new(type))
		if(difference < 0):
			for i in range(0, -1*difference):
				var tmp_cust = active_customers[i]
				# TODO: ez itt igénytelenkedés, inactive queue-ba kéne tennie
				active_customers.erase(tmp_cust)
				tmp_cust.free()
	
	
func update_price(price):
	var customers_to_delete = []
	#check if there is anybody in the active array that doesn't like this price
	for i in range(0, active_customers.size()):
		if(active_customers[i].call('get_quantity', price) <= 0):
			#if there is someone who doesn't like the new price, put in the inactive queue
			passive_customers.push_back(copy_customer(active_customers[i]))
			customers_to_delete.push_back(active_customers[i])
	if DEBUG:
		print('{c} customers put from active to passive because of the price change'.format({'c': customers_to_delete.size()}))
	#delete these customers from old queue
	for i in range(0, customers_to_delete.size()):
		active_customers.erase(customers_to_delete[i])
		customers_to_delete[i].free()
	customers_to_delete.clear()
		
	#check if there is anyone in the passive queue that likes this new price
	for i in range(0, passive_customers.size()):
		if(passive_customers[i].call('get_quantity', price) >= 0):
			#if there is someone who doesn't like the new price, put in the inactive queue
			active_customers.push_back(copy_customer(passive_customers[i]))
			customers_to_delete.push_back(passive_customers[i])
	if DEBUG:
		print('{c} customers put from active to passive because of the price change'.format({'c': customers_to_delete.size()}))
	#delete these customers from old queue
	for i in range(0, customers_to_delete.size()):
		passive_customers.erase(customers_to_delete[i])
		customers_to_delete[i].free()
	customers_to_delete.clear()
	
	#check how many customer is reached with this price, add the necessary amount
	var customers = get_amount_for_all(price)
	for type in customers:
		var new_amount = get_amount_for_type(price, type)
		var existing_amount = get_existing_amount_for_type(type)
		if(new_amount>existing_amount):
			for i in range(0, new_amount-existing_amount):
				active_customers.push_back(Customer.new(type))

#gets a list of customer for buying
#each customer is deciding whether to go to the buffet this time or not based on the satisfaction
#additionally, degrade satisfaction of inactive customers
func get_customers_tick():
	var going_customers = []
	for i in range(0, active_customers.size()):
		var probability_day = float(active_customers[i].satisfaction) / float(SATISFACTION_FREQUENCY)
		var probability_tick = probability_day / float(self.ticks_per_day)
		if(rand_range(0, 1) <= probability_tick):
			going_customers.push_back(active_customers[i])
			
	#degrade inactive customers
	for i in range(0, passive_customers.size()):
		passive_customers[i].call("degrade_satisfaction", self.satisfaction_degradation_per_tick)
		if(passive_customers[i].satisfaction < MIN_SATISFACTION):
			var tmp_cust = passive_customers[i]
			passive_customers.erase(tmp_cust)
			tmp_cust.free()
	
	return going_customers

#call this when a customer has finished shopping
#input: factor is the factor to upgrade/degrade satisfaction
func customer_shopped(customer, factor):
	if(active_customers.find(customer)>0):
		customer.call('upgrade_satisfaction', factor)
	return
	
#instantinate population with actual price
func _init(price, marketing_value, ticks_per_second, seconds_per_day):
	self.marketing = marketing_value
	self.ticks_per_day = ticks_per_second * seconds_per_day
	var amounts = get_amount_for_all(price)
	init_active_customers(amounts, price)
	self.satisfaction_degradation_per_tick = pow(0.5, 1/self.ticks_per_day)
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
