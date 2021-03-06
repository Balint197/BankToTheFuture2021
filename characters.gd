extends PathFollow2D

onready var minScale = 0.8 # bigger is smaller :)

var texture_1 = preload("res://assets/characters/char1.png")
var texture_2 = preload("res://assets/characters/char2.png")
var texture_3 = preload("res://assets/characters/char3.png")
var texture_4 = preload("res://assets/characters/char4.png")

var texture_array = [texture_1, texture_2, texture_3, texture_4]

signal ordering

func _ready():
	generateSprite()
	resize()
	
func _process(delta):
	resize()


func generateSprite():
	randomize()
	var sprite_number = rand_range(0, texture_array.size())
	$sprite.texture = texture_array[sprite_number]

func resize():
	
	scale = Vector2(1 - (unit_offset * minScale), 1 - (unit_offset * minScale))

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "walk_forward":
		emit_signal("ordering")
		
	if anim_name == "walkOut":
		queue_free()
