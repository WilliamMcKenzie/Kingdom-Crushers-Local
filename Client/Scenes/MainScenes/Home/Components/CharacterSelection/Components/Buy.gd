extends PanelContainer

var home_node
var character_selection_node

func _ready():
	var price = 500 + (AccountHandler.data.character_slots * 200)
	
	get_node("VBoxContainer/Cost").text = str(price) + " Gold"
	if price > AccountHandler.data.gold:
		get_node("VBoxContainer/Buy").disabled = true

func _on_Buy_pressed():
	Gateway.BuySlot(character_selection_node)
