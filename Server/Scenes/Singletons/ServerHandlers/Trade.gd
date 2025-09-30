extends Node

onready var server = get_node("/root/Server")

func FindPlayerByName(username):
	for _username in server.player_id_by_name.keys():
		if _username.to_lower() == username.to_lower():
			return server.player_id_by_name[_username]
	return null

func VerifyPlayer(player_id):
	return (
		player_id
		and player_id in server.player_state_collection
		and server.player_state_collection[player_id].instance.GetPlayer(player_id)
	)

func Accept(player_name_1, player_id_2):
	if not FindPlayerByName(player_name_1) or not player_id_2 in server.player_name_by_id: return
	
	var player_id_1 = FindPlayerByName(player_name_1)
	var player_name_2 = server.player_name_by_id[player_id_2]
	
	if not VerifyPlayer(player_id_1) or not VerifyPlayer(player_id_2): return
	
	var instance_1 = server.player_state_collection[player_id_1].instance
	var instance_2 = server.player_state_collection[player_id_2].instance
	var player_container_1 = instance_1.GetPlayer(player_id_1)
	var player_container_2 = instance_2.GetPlayer(player_id_2)
	player_container_1.StartTrade(player_name_2, player_container_2)
	player_container_2.StartTrade(player_name_1, player_container_1)
