extends Node

var max_players = 100
var port = 1912
var network = NetworkedMultiplayerENet.new()
var gameserver_api = MultiplayerAPI.new()
var gameserver_id = 0

func _ready():
	StartServer()

func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func StartServer():
	network.create_server(port, max_players)
	set_custom_multiplayer(gameserver_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	custom_multiplayer.connect("network_peer_connected", self, "_Peer_Connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(id):
	gameserver_id = id

func Token(token, email):
	rpc_id(gameserver_id, "Token", token, email)

remote func AccountData(player_id, email):
	var user = DatabaseInterface.FindUser(email)
	var account_data = user.account_data if user else null
	
	rpc_id(gameserver_id, "ReturnAccountData", player_id, account_data)

remote func UpdateCharacterData(email, character_data, character_index):
	DatabaseInterface.UpdateCharacter(email, character_data, character_index)

remote func UpdateAccountData(email, account_data):
	DatabaseInterface.UpdateUser(email, account_data)
	
remote func UpdateLeaderboard(username, character_data):
	DatabaseInterface.UpdateLeaderboard(username, character_data)

remote func ConfirmUsername(username, player_id):
	var server_id = custom_multiplayer.get_rpc_sender_id()
	var too_long = len(username) > 10
	var too_short = len(username) == 0
	var invalid_characters = not username.is_valid_identifier()
	
	if too_long or too_short or invalid_characters:
		return rpc_id(server_id, "ReturnUsernameConfirmation", -1, username, player_id)
	
	var result = 1 if DatabaseInterface.ConfirmUsername(username, player_id) else 0
	rpc_id(server_id, "ReturnUsernameConfirmation", result, username, player_id)
