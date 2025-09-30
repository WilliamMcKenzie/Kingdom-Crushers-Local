extends Control

var home_node = preload("res://Scenes/MainScenes/Home/Home.tscn")

onready var root = get_node("/root/SceneHandler")
onready var character_node = get_node("PanelContainer/VBoxContainer/CharacterContainer/Character")
onready var continue_node = get_node("PanelContainer/VBoxContainer/Continue")
onready var info_node = get_node("PanelContainer/VBoxContainer/Label")
onready var slots = {
	"weapon" : get_node("PanelContainer/VBoxContainer/Items/weapon"),
	"helmet" : get_node("PanelContainer/VBoxContainer/Items/helmet"),
	"armor" : get_node("PanelContainer/VBoxContainer/Items/armor")
}

var character_class
var target_level = 0
var level = 0

func _physics_process(delta):
	level += (target_level - ((level + target_level) / 2.0)) / 20.0
	info_node.text = "Lv. %d %s" % [round(level), character_class]

func _ready():
	var character = GameHandler.character
	var character_path = ClientData.GetCharacter(character.class).path
	var gear = character.gear
	character_class = character.class
	target_level = character.level
	
	for slot in gear.keys():
		if gear[slot]: slots[slot].SetItem(gear[slot])
		else:
			slots[slot].SetItem(null)
	
	character_node.SetCharacterClass(character_class)
	if "weapon" in gear and gear.weapon != null: 
		character_node.SetCharacterWeapon(ClientData.GetItem(gear.weapon.item).type)
	
	UtilityFunctions.SetSpriteData(character_node, character_path)
	character_node.ColorGear(gear, character.class)

func _on_Continue_pressed():
	root.SwitchScene(home_node.instance())
