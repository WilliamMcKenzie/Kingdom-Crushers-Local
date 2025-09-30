extends PanelContainer

onready var name_node = get_node("Container/Data/Name")
onready var reputation_node = get_node("Container/Data/Reputation")
onready var character_node = get_node("Container/Visuals/CharacterContainer/Sprite")
onready var gear_nodes = {
	"weapon" : get_node("Container/Visuals/Gear/weapon"),
	"helmet" : get_node("Container/Visuals/Gear/helmet"),
	"armor" : get_node("Container/Visuals/Gear/armor"),
}

func SetData(character, index):
	var data = character.data
	var reputation = character.reputation
	var username = character.name
	var gear = data.gear.duplicate()
	
	name_node.text = str(index) + ". " + username
	reputation_node.text = "Lv. " + str(reputation)
	
	for slot in gear.keys():
		gear_nodes[slot].texture = gear_nodes[slot].texture.duplicate()
		var texture = gear_nodes[slot].texture
		
		if gear[slot]:
			var rect_coords = ClientData.GetItem(character.data.gear[slot].item).path[3]*10
			var rect_dimensions = Vector2(10,10)
			texture.region = Rect2(rect_coords, rect_dimensions)
		else:
			texture.region = Rect2(Vector2(200,200), Vector2(0,0))
	
	SetCharacterSprite(character.data, gear)

func SetCharacterSprite(character, gear):
	character_node.material = character_node.material.duplicate()
	
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
