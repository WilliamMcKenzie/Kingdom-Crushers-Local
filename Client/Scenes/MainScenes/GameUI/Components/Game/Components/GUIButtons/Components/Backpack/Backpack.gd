extends Button

onready var inventory = get_node("Inventory")
onready var loot = get_node("Loot")
var id

func Loot(loot_id):
	id = loot_id
	inventory.visible = not loot_id
	loot.visible = not not loot_id

func _on_Backpack_pressed():
	GameUI.Popup(GameUI.inventory_node.instance())
	GameUI.UpdateLoot(id)
