extends ColorRect

onready var scrollPlayer = $AnimationPlayer
onready var upgradeTab = $scrollingContainer/TabContainer

onready var priceScrollBar = $HScrollBar

onready var chef1 = $scrollingContainer/TabContainer/chef/chef1
onready var chef2 = $scrollingContainer/TabContainer/chef/chef2
onready var chef3 = $scrollingContainer/TabContainer/chef/chef3
onready var chef4 = $scrollingContainer/TabContainer/chef/chef4

onready var ingr1 = $scrollingContainer/TabContainer/ingredient/ingredient1
onready var ingr2 = $scrollingContainer/TabContainer/ingredient/ingredient2
onready var ingr3 = $scrollingContainer/TabContainer/ingredient/ingredient3
onready var ingr4 = $scrollingContainer/TabContainer/ingredient/ingredient4

onready var values = [50, 0, 0, 1, 0]
onready var rent = 0 # 0 ... 3
onready var marketing = 0 # 0...100
onready var chef = 1 # 1 ... 4
onready var ingredient = 0 # 0 ... 4

func _ready():
	pass # Replace with function body.


func reportValues():
	ingredient = int(ingr1.pressed) + int(ingr2.pressed) + int(ingr3.pressed) + int(ingr4.pressed)
	values = [priceScrollBar.value, rent, marketing, chef, ingredient]
	return values
	
func scrollToUpgrades():
	scrollPlayer.play("scroll")



func _on_TextureButton_button_up():
	scrollToUpgrades()
	upgradeTab.current_tab = 0


func _on_TextureButton2_button_up():
	scrollToUpgrades()
	upgradeTab.current_tab = 1

func _on_TextureButton3_button_up():
	scrollToUpgrades()
	upgradeTab.current_tab = 2

func _on_TextureButton4_button_up():
	scrollToUpgrades()
	upgradeTab.current_tab = 3


func _on_TextureButton_button_down():
	scrollPlayer.play("scrollBack")


func _on_rent1_button_up():
	rent += 1
	$scrollingContainer/TabContainer/rent/rent1.disabled = true
	$scrollingContainer/TabContainer/rent/rent2.disabled = false


func _on_rent2_button_up():
	rent += 1
	$scrollingContainer/TabContainer/rent/rent2.disabled = true
	$scrollingContainer/TabContainer/rent/rent3.disabled = false


func _on_rent3_button_up():
	rent += 1
	$scrollingContainer/TabContainer/rent/rent3.disabled = true


func _on_marketingSlider_value_changed(value):
	marketing = value


func _on_chef1_button_down():
	chef2.pressed = false
	chef3.pressed = false
	chef4.pressed = false
	chef = 1

func _on_chef2_button_down():
	chef1.pressed = false
	chef3.pressed = false
	chef4.pressed = false
	chef = 2

func _on_chef3_button_down():
	chef2.pressed = false
	chef1.pressed = false
	chef4.pressed = false
	chef = 3

func _on_chef4_button_down():
	chef2.pressed = false
	chef1.pressed = false
	chef3.pressed = false
	chef = 4
