extends ColorRect

onready var scrollPlayer = $AnimationPlayer
onready var upgradeTab = $scrollingContainer/TabContainer

func _ready():
	pass # Replace with function body.


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
