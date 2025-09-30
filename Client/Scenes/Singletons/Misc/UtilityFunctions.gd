extends Node

func IdentifierToString(identifier):
	if not identifier:
		return ""
	
	var words = identifier.split("_")
	var proper_string = ""
	for word in words:
		proper_string += word.capitalize() + " "
	proper_string = proper_string.strip_edges()

	return proper_string

func SetCharacterSprite(character, node):
	SetSpriteData(node, ClientData.GetCharacter(character.class).path)
	node.ColorGear(character.gear, character.class)
	node.SetCharacterClass(character.class)
	
	if character.gear.has("weapon") and character.gear.weapon != null: 
		node.SetCharacterWeapon(ClientData.GetItem(character.gear.weapon.item).type)

func SetSpriteData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0]) 
	sprite.texture = spriteTexture
	sprite.hframes = path[1]
	sprite.vframes = path[2]
	sprite.frame_coords = path[3]

func SetTextureData(sprite, path):
	var spriteTexture = load("res://Assets/"+path[0])
	sprite.texture = AtlasTexture.new()
	sprite.texture.atlas = spriteTexture
	sprite.texture.region = Rect2(path[3]*10, Vector2(10,10))

func CompareArrays(arr1, arr2):
	if arr1.size() != arr2.size():
		return false

	for i in range(arr1.size()):
		if typeof(arr1[i]) != typeof(arr2[i]):
			return false

		match typeof(arr1[i]):
			TYPE_NIL:
				if arr1[i] != arr2[i]:
					return false
			TYPE_DICTIONARY:
				if not CompareDictionaries(arr1[i], arr2[i]):
					return false
			_:
				if arr1[i] != arr2[i]:
					return false
	return true

func CompareDictionaries(dict1, dict2):
	return dict1.hash() == dict2.hash()
