extends Node2D

onready var area_node = get_node("Area2D")
onready var item_node = get_node_or_null("Item")

export var item_stand = false
var object_id
var loot

func UpdateLoot(_loot):
	loot = _loot
	if item_stand and loot[0]:
		var item_coords = ClientData.GetItem(loot[0].item).path[3]
		item_node.frame_coords = item_coords
		item_node.visible = true
	elif item_stand:
		item_node.visible = false

func _on_Area2D_area_entered(area):
	if "main_player" in area.get_parent().get_parent():
		GameUI.Loot(object_id, loot, position)

func _on_Area2D_area_exited(area):
	if "main_player" in area.get_parent().get_parent():
		GameUI.OffLoot(object_id)
