extends Control

var inspect_node = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/InspectItem/InspectItem.tscn")

onready var loot_node = get_node("LootContainer")
onready var loot_slots_node = get_node("LootContainer/PanelContainer/VBoxContainer")
onready var inventory_node = get_node("BackpackContainer")
onready var inventory_slots_node = get_node("BackpackContainer/PanelContainer/VBoxContainer")
onready var gear_node = get_node("PanelContainer")
onready var gear_slots_node = get_node("PanelContainer/HBoxContainer")

var inspect_instance
var loot_id
var loot = []
var item = null

func _ready():
	SetInventory(GameHandler.character.inventory)
	SetGear(GameHandler.character.gear)

func InspectItem(data, parent):
	if not data: return
	if item: return OffItem()
	item = ClientData.GetItem(data.item)
	
	inspect_instance = inspect_node.instance()
	
	if parent == "inventory":
		inventory_node.add_child(inspect_instance)
		inventory_node.move_child(inspect_instance, 0)
	if parent == "gear":
		add_child(inspect_instance)
	else:
		loot_node.add_child(inspect_instance)
	inspect_instance.Inspect(item, data)

func OffItem():
	item = null
	if is_instance_valid(inspect_instance): inspect_instance.queue_free()

func SetInventory(inventory):
	var inventory_slots = inventory_slots_node.get_children()
	var i = 0
	
	for slot in inventory_slots:
		slot.SetItem(inventory[i])
		slot.inventory_node = self
		slot.parent = "inventory"
		slot.index = i
		i += 1

func SetGear(gear):
	var gear_slots = gear_slots_node.get_children()
	var gear_types = [
		"weapon",
		"helmet",
		"armor"
	]
	
	for slot_index in range(0, 3):
		var gear_type = gear_types[slot_index]
		var slot = gear_slots[slot_index]
		
		slot.inventory_node = self
		slot.parent = "gear"
		slot.index = gear_type
		
		if gear_type in gear: slot.SetItem(gear[gear_type])
		else: slot.SetItem(null)

func UpdateLoot(id):
	var bag = GameHandler.instance_node.get_node_or_null("YSort/Objects/LootBags/%s" % [id])
	var loot_slots = loot_slots_node.get_children()
	
	if bag and loot and UtilityFunctions.CompareArrays(bag.loot, loot): return
	loot = bag.loot if bag else null
	
	if loot:
		var size = len(loot)
		var i = 0
		
		for slot in loot_slots:
			var valid = size > i
			slot.visible = valid
			if valid:
				slot.SetItem(loot[i])
				slot.inventory_node = self
				slot.parent = id
				slot.index = i
				i += 1
	
	loot_node.visible = true if loot else false
	loot_id = id

func _on_Close_pressed():
	GameUI.Popup(GameUI.game_node.instance())
