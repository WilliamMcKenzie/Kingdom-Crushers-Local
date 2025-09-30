extends Node

var max_players = 100
var port = 20201

var network = WebSocketServer.new()
var gateway_api = MultiplayerAPI.new()
var player_id_by_email = {}

func _ready():
	VisualServer.render_loop_enabled = false
	StartServer()

func _process(delta):
	if custom_multiplayer:
		custom_multiplayer.poll()

func StartServer():
	var result = network.listen(port, PoolStringArray(), true);
	if result != OK:
		print("Failed to start server")
	else:
		print("Server is running on port ", port)
	
	get_tree().set_network_peer(network);
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)

	custom_multiplayer.connect("network_peer_connected", self, "_Peer_Connected")
	custom_multiplayer.connect("network_peer_disconnected", self, "_Peer_Disconnected")

func _Peer_Connected(id):
	print("User connected")
func _Peer_Disconnected(id):
	print("User disconnected")


# Generic return
func Return(data, player_id):
	rpc_id(player_id, "Return", data)


# Login
remote func Login(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.Login(email, password, player_id)

# Signup
remote func Signup(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.Signup(email, password, player_id)

#Guest
remote func Guest(token):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.Guest(token, player_id)

# Leaderboard
remote func Leaderboard():
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.Leaderboard(player_id)

func ReturnLeaderboard(weekly, monthly, all_time, player_id):
	rpc_id(player_id, "ReturnLeaderboard", weekly, monthly, all_time)


# Revive
remote func Revive(email, password, index):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.Revive(email, password, index, player_id)

# Buy slot
remote func BuySlot(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.BuySlot(email, password, player_id)

# Create character
remote func CreateCharacter(email, password):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.CreateCharacter(email, password, player_id)


# Tokens
remote func GetToken(email):
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.GetToken(email, player_id)

func ReturnToken(token, player_id):
	rpc_id(player_id, "ReturnToken", token)
