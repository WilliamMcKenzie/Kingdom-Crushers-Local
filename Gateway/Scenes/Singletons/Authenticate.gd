extends Node

var ip_address = "localhost"
var port = 1913
var network = NetworkedMultiplayerENet.new()

func _ready():
	ConnectToServer()

func ConnectToServer():
	network.create_client(ip_address, port)
	get_tree().network_peer = network


# Generic return
remote func Return(data, player_id):
	Gateway.Return(data, player_id)

# Login
func Login(email, password, player_id):
	rpc_id(1, "Login", email, password, player_id)


# Signup
func Signup(email, password, player_id):
	rpc_id(1, "Signup", email, password, player_id)


# Guest
func Guest(token, player_id):
	rpc_id(1, "Guest", token, player_id)


# Leaderboard
func Leaderboard(player_id):
	rpc_id(1, "Leaderboard", player_id)

remote func ReturnLeaderboard(weekly, monthly, all_time, player_id):
	Gateway.ReturnLeaderboard(weekly, monthly, all_time, player_id)


# Revive
func Revive(email, password, index, player_id):
	rpc_id(1, "Revive", email, password, index, player_id)

# Buy slot
func BuySlot(email, password, player_id):
	rpc_id(1, "BuySlot", email, password, player_id)

# Create character
func CreateCharacter(email, password, player_id):
	rpc_id(1, "CreateCharacter", email, password, player_id)


# Tokens
func GetToken(email, player_id):
	rpc_id(1, "GetToken", email, player_id)

remote func ReturnToken(token, player_id):
	Gateway.ReturnToken(token, player_id)
