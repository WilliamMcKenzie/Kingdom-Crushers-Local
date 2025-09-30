extends Button

onready var name_node = get_node("MarginContainer/HBoxContainer/HBoxContainer/Info/Name")
onready var level_node = get_node("MarginContainer/HBoxContainer/HBoxContainer/Info/Level")
onready var character_node = get_node("MarginContainer/HBoxContainer/CharacterContainer/Character")
onready var slots = {
	"weapon" : get_node("MarginContainer/HBoxContainer/HBoxContainer/Items/weapon"),
	"helmet" : get_node("MarginContainer/HBoxContainer/HBoxContainer/Items/helmet"),
	"armor" : get_node("MarginContainer/HBoxContainer/HBoxContainer/Items/armor")
}

var nearby_node
var data

func _on_Player_pressed():
	nearby_node.Player(data)

func Player(player_data):
	data = player_data
	var name = data.name
	var gear = data.sprite.gear
	var level = data.sprite.level
	var classname = data.sprite.class
	
	UtilityFunctions.SetCharacterSprite(data.sprite, character_node)
	name_node.text = name
	level_node.text = "Lv. %d" % [level]
	
	for slot in gear.keys():
		var item = gear[slot]
		slots[slot].SetItem(item)
