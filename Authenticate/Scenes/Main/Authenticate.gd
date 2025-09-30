extends Node

var max_players = 100
var port = 1913
var network = NetworkedMultiplayerENet.new()

func _ready():
	VisualServer.render_loop_enabled = false
	StartServer()

func StartServer():
	network.create_server(port, max_players)
	get_tree().network_peer = network
	print("Server started")
	
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(id):
	print("Gateway " + str(id) + " has connected to authentication server!")
func _Peer_Disconnected(id):
	print("Gateway " + str(id) + " has disconnected to authentication server!")

var player_id_by_email = {}

remote func Login(email, password, player_id):
	var gateway_id = get_tree().get_rpc_sender_id()
	var verification = DatabaseInterface.VerifyUser(email, password)
	var account_data = null
	
	if verification:
		account_data = DatabaseInterface.FindUser(email).account_data
		player_id_by_email[email] = player_id
	
	rpc_id(gateway_id, "Return", account_data, player_id)


remote func Signup(email, password, player_id):
	var email_used = DatabaseInterface.FindUser(email) != null
	var gateway_id = get_tree().get_rpc_sender_id()
	
	if not email_used:
		var account_data = DatabaseInterface.AddUser(email, password)
		rpc_id(gateway_id, "Return", account_data, player_id)
	else:
		rpc_id(gateway_id, "Return", null, player_id)


remote func Guest(token, player_id):
	var gateway_id = get_tree().get_rpc_sender_id()
	rpc_id(gateway_id, "Return", DatabaseInterface.AddUser(token, token), player_id)


remote func Leaderboard(player_id):
	var gateway_id = get_tree().get_rpc_sender_id()
	var weekly = DatabaseInterface.weekly_leaderboard
	var monthly = DatabaseInterface.monthly_leaderboard
	var all_time = DatabaseInterface.all_time_leaderboard
	
	rpc_id(gateway_id, "ReturnLeaderboard", weekly, monthly, all_time, player_id)


remote func Revive(email, password, index, player_id):
	var verification = DatabaseInterface.VerifyUser(email, password)
	if verification:
		var gateway_id = get_tree().get_rpc_sender_id()
		var account_data = DatabaseInterface.FindUser(email).account_data

		var gold = account_data.gold
		var cost = account_data.graveyard[index].revive_cost
		var permadead = "permadead" in account_data.graveyard[index]
		var char_slots = account_data.character_slots
		var characters = account_data.characters
		
		var index_out_of_bounds = len(account_data.graveyard) < index + 1
		var not_enough_slots = len(characters) >= char_slots
		var not_enough_gold = gold < cost
		
		if not index_out_of_bounds and not not_enough_gold and not not_enough_slots and not permadead:
			DatabaseInterface.ReviveCharacter(email, index, player_id, gateway_id)


remote func BuySlot(email, password, player_id):
	var verification = DatabaseInterface.VerifyUser(email, password)
	if verification:
		var gateway_id = get_tree().get_rpc_sender_id()
		var account_data = DatabaseInterface.FindUser(email).account_data
		
		var character_slots = account_data.character_slots
		var price = 500 + (character_slots * 200)
		var gold = account_data.gold
		
		if gold >= price:
			account_data.character_slots += 1
			account_data.gold -= price
			DatabaseInterface.UpdateUser(email, account_data)
		rpc_id(gateway_id, "Return", account_data, player_id)


remote func CreateCharacter(email, password, player_id):
	var verification = DatabaseInterface.VerifyUser(email, password)
	if verification:
		var gateway_id = get_tree().get_rpc_sender_id()
		var account_data = DatabaseInterface.FindUser(email).account_data

		var char_slots = account_data.character_slots
		var characters = account_data.characters
		
		if char_slots > len(characters): account_data = DatabaseInterface.CreateCharacter(email)
		rpc_id(gateway_id, "Return", account_data, player_id)


remote func GetToken(email, player_id):
	randomize()
	var gateway_id = get_tree().get_rpc_sender_id()
	var token = str(randi()).sha256_text() + str(OS.get_unix_time())

	GameServers.Token(token, email)
	rpc_id(gateway_id, "ReturnToken", token, player_id)



#func generate_unique_id():
#    var timestamp = OS.get_unix_time()
#    var random_value = randi()
#    return (str(timestamp) + "_" + str(random_value)).sha256_text()


#
#
#remote func FetchAccountData(email, password, player_id):
#    var verification = DatabaseInterface.VerifyUser(email, password)
#    if not verification:
#        return
#
#    var gateway_id = get_tree().get_rpc_sender_id()
#    var account_data = DatabaseInterface.FindUser(email).account_data
#
#    rpc_id(gateway_id, "ReturnAccountData", account_data, player_id)
#
#remote func BuyCharacterSlot(email, password, player_id):
#    var verification = DatabaseInterface.VerifyUser(email, password)
#    if not verification:
#        return
#
#    var gateway_id = get_tree().get_rpc_sender_id()
#    var result = false
#    var account_data = DatabaseInterface.FindUser(email).account_data
#
#    var character_slots = account_data.character_slots
#    var gold = account_data.gold
#
#    var price = 500 + (character_slots*200)
#
#    if gold > price:
#        result = true
#        account_data.character_slots += 1
#        account_data.gold -= price
#        DatabaseInterface.UpdateUser(email, account_data)
#    rpc_id(gateway_id, "ReturnBuyCharacterSlotRequest", result, player_id)
#
#func generate_unique_id():
#    var timestamp = OS.get_unix_time()
#    var random_value = randi()
#    return (str(timestamp) + "_" + str(random_value)).sha256_text()
#
#remote func CreateCharacter(email, password, player_id):
#    var verification = DatabaseInterface.VerifyUser(email, password)
#    if not verification:
#        return
#
#    var gateway_id = get_tree().get_rpc_sender_id()
#    var result = false
#    var account_data = DatabaseInterface.FindUser(email).account_data
#
#    var char_slots = account_data.character_slots
#    var characters = account_data.characters
#
#    if char_slots > characters.size():
#        result = true
#        DatabaseInterface.CreateCharacter(email)
#
#    rpc_id(gateway_id, "ReturnCreateCharacterRequest", result, DatabaseInterface.new_character, player_id)
#
#remote func ReviveCharacter(index, email, password, player_id):
#    var verification = DatabaseInterface.VerifyUser(email, password)
#    if not verification:
#        return
#
#    var gateway_id = get_tree().get_rpc_sender_id()
#    var result = false
#    var account_data = DatabaseInterface.FindUser(email).account_data
#
#    if account_data.graveyard.size() < index+1:
#        return
#
#    var gold = account_data.gold
#    var cost = account_data.graveyard[index].revive_cost
#    var permadead = account_data.graveyard[index].has("permadead")
#    var char_slots = account_data.character_slots
#    var characters = account_data.characters
#
#    var not_enough_slots = characters.size() >= char_slots
#    var not_enough_gold = gold < cost
#
#    if not_enough_gold or not_enough_slots or permadead:
#        return
#    DatabaseInterface.ReviveCharacter(email, index, player_id, gateway_id)
#

#
#remote func SendToken(email, player_id):
#    randomize()
#    var gateway_id = get_tree().get_rpc_sender_id()
#    var token = str(randi()).sha256_text() + str(OS.get_unix_time())
#    var gameserver = "GameServer1"
#
#    GameServers.DistributeLogToken(token, email, gameserver)
#    rpc_id(gateway_id, "ReturnToken", token, player_id)
#
#remote func GetLeaderboards(player_id):
#    var gateway_id = get_tree().get_rpc_sender_id()
#    var weekly = DatabaseInterface.weekly_leaderboard
#    var monthly = DatabaseInterface.monthly_leaderboard
#    var all_time = DatabaseInterface.all_time_leaderboard
#
#    rpc_id(gateway_id, "ReturnLeaderboardsResult", weekly, monthly, all_time, player_id)
#
#remote func VerifyPurchase(token,type,value,username):
#    DatabaseInterface.HandlePayment(type,value,username)


