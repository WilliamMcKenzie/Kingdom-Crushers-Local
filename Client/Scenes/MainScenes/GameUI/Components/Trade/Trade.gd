extends Control

var game_node = preload("res://Scenes/MainScenes/GameUI/Components/Game/Game.tscn")
var inspect_node = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/InspectItem/InspectItem.tscn")

onready var inventory_node = get_node("You")
onready var other_inventory_node = get_node("Other")
onready var accept_node = get_node("You/Options/Accept")
onready var cancel_node = get_node("You/Options/Cancel")
onready var your_slots = get_node("You/PanelContainer/VBoxContainer").get_children()
onready var other_slots = get_node("Other/PanelContainer/VBoxContainer").get_children()
onready var other_name_node = get_node("Other/Name")
onready var name_node = get_node("You/Options/Name")

var your_offer = [false, false, false, false, false, false, false, false]
var accepted_color = Color("9bc53d")
var inspect_instance
var item = null

func InspectItem(data, parent):
	if not data: return
	if item: return OffItem()
	item = ClientData.GetItem(data.item)
	
	inspect_instance = inspect_node.instance()
	if parent == "inventory":
		inventory_node.add_child(inspect_instance)
		inventory_node.move_child(inspect_instance, 0)
	else:
		other_inventory_node.add_child(inspect_instance)
	inspect_instance.Inspect(item, data)

func OffItem():
	item = null
	if is_instance_valid(inspect_instance): inspect_instance.queue_free()

func Toggle(index, node):
	var is_active = your_offer[index]
	your_offer[index] = not is_active
	
	if is_active: node.Deactivate()
	else: node.Activate()
	
	Server.Send("Offer", your_offer)

func Overflow(inventory, other_inventory, selection):
	var free_slots = 0
	var selection_count = 0
	var other_free_slots = 0
	var other_selection_count = 0
	
	for item in inventory: if not item: free_slots += 1
	for item in your_offer: if item:
		selection_count += 1
	for item in other_inventory: if not item: other_free_slots += 1
	for item in selection: if item:
		other_selection_count += 1
	
	var overflow = (
		free_slots < other_selection_count
		or other_free_slots < selection_count
	)
	
	accept_node.disabled = overflow

func Set(data):
	var inventory = GameHandler.character.inventory
	var other_inventory = data.inventory
	var selection = data.selection
	var other_name = data.name
	var accepted = data.accepted
	
	if not accepted:
		accept_node.disabled = false
		cancel_node.disabled = false
		other_name_node.remove_color_override("font_color")
		name_node.remove_color_override("font_color")
	else:
		other_name_node.add_color_override("font_color", accepted_color)
	
	for i in range(8):
		var slot = your_slots[i]
		slot.SetItem(inventory[i])
		slot.inventory_node = self
		slot.parent = "inventory"
		slot.index = i
		if your_offer[i]: slot.Activate()
		else: slot.Deactivate()
	for i in range(8):
		var slot = other_slots[i]
		slot.SetItem(other_inventory[i])
		slot.inventory_node = self
		slot.parent = "other"
		slot.index = i
		if selection[i]: slot.Activate()
		else: slot.Deactivate()
	
	other_name_node.text = other_name
	Overflow(inventory, other_inventory, selection)

func _on_Cancel_pressed():
	Server.SendEmpty("CancelOffer")
	GameUI.Popup(GameUI.game_node.instance())

func _on_Accept_pressed():
	Server.SendEmpty("AcceptOffer")
	name_node.add_color_override("font_color", accepted_color)
	accept_node.disabled = true
	cancel_node.disabled = true
