extends Node

#var ip = "159.203.0.78"
var ip = "localhost"
var port = 1912
var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

onready var server = get_node("/root/Server")

func _ready():
	ConnectToServer()

func _process(delta):
	if get_custom_multiplayer() == null: return
	if not custom_multiplayer.has_network_peer(): return
	custom_multiplayer.poll()

func ConnectToServer():
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

remote func Token(token, email):
	server.expected_tokens[token] = email

var players = {}

func AccountData(player_id, player_container, email):
	players[player_id] = player_container
	rpc_id(1, "AccountData", player_id, email)

remote func ReturnAccountData(player_id, account_data):
	if not account_data:
		print("Hub issue")
		return server.network.disconnect_peer(int(player_id))
	
	var player_container = players[player_id]
	
	server.player_name_by_id[player_id] = account_data.username
	server.player_id_by_name[account_data.username] = player_id
	player_container.instance.player_list[str(player_id)].name = account_data.username
	player_container.AccountData(account_data)
	
	if not "tutorial" in account_data or not account_data.tutorial:
		server.Tutorial(player_container)


func UpdateCharacterData(email, character_data, character_index):
	rpc_id(1, "UpdateCharacterData", email, character_data, character_index)


func UpdateAccountData(email, account_data):
	rpc_id(1, "UpdateAccountData", email, account_data)


func UpdateLeaderboard(username, character_data):
	var character = { "gear" : character_data.gear, "class" : character_data.class, "level" : character_data.level}
	rpc_id(1, "UpdateLeaderboard", username, character)


func ConfirmUsername(username, player_id):
	rpc_id(1, "ConfirmUsername", username, player_id)

remote func ReturnUsernameConfirmation(result, username, player_id):
	server.ConfirmUsername(result, username, player_id)
