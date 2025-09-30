extends HBoxContainer

onready var inventory_button = get_node("Backpack")
onready var building_button = get_node("Building")

onready var active_node = get_node("Toggle")
onready var inactive_node = get_node("VBoxContainer")

var last_toggled = 0
func Toggle():
	if OS.get_system_time_msecs() - last_toggled < 100:
		return
	last_toggled = OS.get_system_time_msecs()
	
	active_node.visible = false
	inactive_node.visible = true
	
	var temp = active_node
	active_node = inactive_node
	inactive_node = temp

func Loot(loot_id):
	inventory_button.Loot(loot_id)
