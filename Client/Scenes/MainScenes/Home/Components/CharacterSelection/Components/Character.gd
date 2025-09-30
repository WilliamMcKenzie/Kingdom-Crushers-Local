extends PanelContainer

var home_node
var character_selection_node

onready var character_node = get_node("VBoxContainer/CharacterContainer/Character")
onready var play_node = get_node("VBoxContainer/Play")
onready var title_node = get_node("VBoxContainer/Title")
onready var slots = {
	"weapon" : get_node("VBoxContainer/Items/weapon"),
	"helmet" : get_node("VBoxContainer/Items/helmet"),
	"armor" : get_node("VBoxContainer/Items/armor")
}

var character
var character_index

func _ready():
	var character_path = ClientData.GetCharacter(character.class).path
	var character_class = character.class
	var character_level = character.level
	var gear = character.gear
	
	for slot in gear.keys():
		if gear[slot]: slots[slot].SetItem(gear[slot])
		else:
			slots[slot].SetItem(null)
	
	character_node.SetCharacterClass(character_class)
	if gear.has("weapon") and gear.weapon != null: 
		character_node.SetCharacterWeapon(ClientData.GetItem(gear.weapon.item).type)
	
	UtilityFunctions.SetSpriteData(character_node, character_path)
	character_node.ColorGear(gear, character.class)
	title_node.text = character_class + " - Lv. " + str(character_level)

func Disable():
	play_node.disabled = true

func _on_Play_pressed():
	home_node.EnterGame(character_index)
