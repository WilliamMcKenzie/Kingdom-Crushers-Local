extends Node

onready var server = get_node("/root/Server")

func UseItem(index, player_id):
	var instance = server.player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	player_container.UseItem(index)

func EquipItem(index, player_id):
	var instance = server.player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	player_container.EquipItem(index)

func SwapItem(to_data, from_data, player_id):
	var instance = server.player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	
	var loot = to_data.parent.split(" ")[0] == "loot" or from_data.parent.split(" ")[0] == "loot"
	var storage = to_data.parent.split(" ")[0] == "storage" or from_data.parent.split(" ")[0] == "storage"
	
	if loot or storage:
		player_container.LootItem(to_data, from_data)
	else:
		player_container.ChangeItem(to_data, from_data)

func DropItem(data, player_id):
	var instance = server.player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	player_container.DropItem(data)
