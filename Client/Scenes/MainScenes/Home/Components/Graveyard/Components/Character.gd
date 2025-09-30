extends PanelContainer

var graveyard_node

var cost
var index

onready var character_node = get_node("MarginContainer/Container/Visuals/CharacterContainer/Sprite")
onready var level_node = get_node("MarginContainer/Container/Data/Level")
onready var revive_node = get_node("MarginContainer/Container/Revive")
onready var permadead_node = get_node("MarginContainer/Container/Permadead")
onready var gear_nodes = {
	"weapon" : get_node("MarginContainer/Container/Visuals/Gear/weapon"),
	"helmet" : get_node("MarginContainer/Container/Visuals/Gear/helmet"),
	"armor" : get_node("MarginContainer/Container/Visuals/Gear/armor")
}

func _physics_process(delta):
	var data = AccountHandler.data
	var not_enough_slots = len(data.characters) >= data.character_slots
	var not_enough_gold = data.gold < cost
	var permadead = cost == 9999999
	
	if permadead:
		revive_node.visible = false
		permadead_node.visible = true
	elif not_enough_slots:
		revive_node.disabled = true
		revive_node.text = "No avaliable slots"
	elif not_enough_gold: 
		revive_node.disabled = true
	else: revive_node.disabled = false

func SetData(character, index):
	var reputation = character.level
	var gear = character.gear.duplicate()
	
	cost = character.revive_cost
	revive_node.text = "Revive " + str(cost)
	level_node.text = str(reputation)
	
	for slot in gear.keys():
		gear_nodes[slot].texture = gear_nodes[slot].texture.duplicate()
		var texture = gear_nodes[slot].texture
		
		if gear[slot]:
			var rect_coords = ClientData.GetItem(character.gear[slot].item).path[3]*10
			var rect_dimensions = Vector2(10,10)
			texture.region = Rect2(rect_coords, rect_dimensions)
		else:
			texture.region = Rect2(Vector2(200,200), Vector2(0,0))
	
	SetCharacterSprite(character, gear)

func SetCharacterSprite(character, gear):
	character_node.material = character_node.material.duplicate()
	var weapon_type = "Sword"
	
	SetSpriteData(character_node, ClientData.GetCharacter(character.class).path)
	character_node.SetCharacterClass(character.class)
	character_node.ColorGear(gear, character.class)
	if gear.weapon:
		character_node.SetCharacterWeapon(ClientData.GetItem(gear.weapon.item).type)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

func _on_Revive_pressed():
	Gateway.Revive(index, graveyard_node)
