extends TextureButton

onready var touchscreen_button = get_node("TouchScreenButton")
onready var background_node = get_node("Background")
onready var icon_node = get_node("Icon")

var dragging = false
var last_click = 999
var inventory_node
var parent
var index
var item

func _physics_process(delta): last_click += delta

func _ready():
	if GameHandler.is_mobile: touchscreen_button.connect("pressed", self, "Interaction")
	else: connect("pressed", self, "Interaction")

func get_drag_data(position):
	if not item: return
	dragging = true
	
	var drag_texture = TextureRect.new()
	drag_texture.texture = AtlasTexture.new()
	drag_texture.texture.atlas = icon_node.texture.atlas.duplicate(true)
	drag_texture.texture.region = icon_node.texture.region
	drag_texture.material = icon_node.material.duplicate()
	drag_texture.rect_position = -0.5 * Vector2(70,70)
	drag_texture.rect_size = Vector2(70,70)
	drag_texture.expand = true
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	set_drag_preview(preview)
	icon_node.visible = false
	
	var data = {}
	data.parent = parent
	data.index = index
	data.item = item.item
	return data
	
func can_drop_data(position, data): return true
	
func drop_data(position, data):
	var current_data = {
		"parent" : parent,
		"index" : index
	}
	Server.Send("SwapItem", [current_data, data])
	if "loot" in data.parent and "inventory" in parent:
		GameUI.GotItem(data.item)
	if "inventory" in data.parent and "gear" in parent:
		GameUI.UseItem(data.item)
	if "loot" in data.parent and "gear" in parent:
		GameUI.UseItem(data.item)

func Interaction():
	var doubleclick = item and last_click < 1
	var inventory = GameHandler.character.inventory
	last_click = 1
	
	if doubleclick and "inventory" == parent:
		GameUI.UseItem(item.item)
		Server.Send("EquipItem", index)
		if GameHandler.tutorial < 0 or GameHandler.tutorial > 14:
			Server.Send("UseItem", index)
	elif doubleclick and "loot" in parent:
		var i = 0
		for slot in inventory:
			if not slot:
				var current_data = {
					"parent" : "inventory",
					"index" : i
				}
				var data = {
					"parent" : parent,
					"index" : index
				}
				GameUI.GotItem(item.item)
				Server.Send("SwapItem", [current_data, data])
				break
			i += 1
	else: last_click = 0
	
	inventory_node.InspectItem(item, parent)

func DeInspectItem():
	if item: inventory_node.OffItem()

func SetItem(_item):
	item = _item
	
	if not item:
		icon_node.visible = false
		background_node.visible = true
	else:
		icon_node.visible = true
		background_node.visible = false
		UtilityFunctions.SetTextureData(icon_node, ClientData.GetItem(item.item).path)
