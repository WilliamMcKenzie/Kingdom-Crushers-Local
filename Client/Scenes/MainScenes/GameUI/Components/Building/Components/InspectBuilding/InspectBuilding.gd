extends PanelContainer

onready var name_node = get_node("VBoxContainer/Name")
onready var description_node = get_node("VBoxContainer/ItemDescription")
onready var sprite_node = get_node("VBoxContainer/TextureRect")
onready var info_node = get_node("VBoxContainer/VBoxContainer")
onready var craftable_node = info_node.get_node("Craftable")
onready var materials_node = info_node.get_node("VBoxContainer")

func Inspect(data):
	var craftable = data.craftable
	var path = data.path
	var wall = "wall" in data
	var tile = "tileset" in path[0]
	
	if craftable:
		craftable_node.visible = true
		materials_node.visible = true
		materials_node.get_node("Materials").SetMaterials(data.materials)
	else:
		description_node.visible = true
	
	name_node.text = data.name
	description_node.text = data.description
	UtilityFunctions.SetTextureData(sprite_node, path)
	sprite_node.texture.region = Rect2(path[3], Vector2(260 / path[2], 260 / path[2]))
	
	if wall:
		sprite_node.texture.region = Rect2(path[3], Vector2(10,20))
	if tile:
		sprite_node.material = null
