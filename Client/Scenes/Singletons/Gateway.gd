extends Node

#var url = "ws://159.203.0.78:20201"
var url = "ws://localhost:20201"

var ip_address = "localhost"

var network = WebSocketClient.new();
var gateway_api = MultiplayerAPI.new()

var requesting_node

func Connect(node):
	network.connect_to_url(url, PoolStringArray(), true)
	
	gateway_api = MultiplayerAPI.new()
	
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	yield(get_tree().create_timer(3), "timeout")
	
	if network.get_connection_status() != network.CONNECTION_CONNECTED:
		node.GatewayConnection(false)
	else:
		node.GatewayConnection(true)

func _process(delta):
	if custom_multiplayer:
		custom_multiplayer.poll()

# Generic return
remote func Return(data):
	if data:
		AccountHandler.data = data
	
	if is_instance_valid(requesting_node):
		requesting_node.Return()

# Login
func Login(email, password, node):
	requesting_node = node
	rpc_id(1, "Login", email, password)

# Signup
func Signup(email, password, node):
	requesting_node = node
	rpc_id(1, "Signup", email, password)

func Guest(token, node):
	requesting_node = node
	rpc_id(1, "Guest", token)

# Leaderboard
func Leaderboard(node):
	requesting_node = node
	rpc_id(1, "Leaderboard")

remote func ReturnLeaderboard(weekly, monthly, all_time):
	requesting_node.Return(weekly, monthly, all_time)


# Revive
func Revive(index, node):
	requesting_node = node
	rpc_id(1, "Revive", AccountHandler.email, AccountHandler.password, index)

# Buy slot
func BuySlot(node):
	requesting_node = node
	rpc_id(1, "BuySlot", AccountHandler.email, AccountHandler.password)

# Create character
func CreateCharacter(node):
	requesting_node = node
	rpc_id(1, "CreateCharacter", AccountHandler.email, AccountHandler.password)


# Get token
func GetToken(node):
	requesting_node = node
	rpc_id(1, "GetToken", AccountHandler.email)

remote func ReturnToken(token):
	Server.Connect(token, requesting_node)
