extends Button

var id

func _on_Loot_pressed():
	GameUI.Popup(GameUI.inventory_node.instance())
	GameUI.UpdateLoot(id)
