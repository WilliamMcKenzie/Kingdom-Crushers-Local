extends VBoxContainer

onready var animator = get_node("AnimationPlayer")
onready var exp_node = get_node("HBoxContainer/Exp/ExpBar")
onready var exp_label = get_node("HBoxContainer/Label")
var last_level = 0

func _ready():
	var character = GameHandler.character
	animator.play("RESET")
	
	if character:
		last_level = character.level
		exp_label.text = "Lv %d" % [last_level]
		
		exp_node.max_value = 200 * character.level if (character.level < 10) else 2500
		exp_node.value = character.exp

func SetExp(total, new, level):
	if level > last_level:
		last_level = level
		animator.play("Level")
	
	exp_label.text = "Lv %d" % [level]
	
	exp_node.max_value = total
	exp_node.value = new
