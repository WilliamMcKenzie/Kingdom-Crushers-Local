extends Node

onready var server = get_node("/root/Server")
onready var player_node = preload("res://Scenes/SupportScenes/PlayerContainer.tscn")

var waitlist = {}
var verified = {}

func Start(player_id):
	waitlist[player_id] = { "time" : OS.get_unix_time()}
	server.Token(player_id)

func Verify(player_id, token, character_index):
	var success = false
	
	while OS.get_unix_time() - int(token.right(64)) <= 3:
		var tokens = server.expected_tokens
		if tokens and token in tokens:
			var email = tokens[token]
			
			#Check if same account is already in the game
			if email in verified:
				success = false
				server.network.disconnect_peer(verified[email])
				verified.erase(email)
				break
			
			success = true
			waitlist.erase(player_id)
			server.expected_tokens.erase(token)
			verified[email] = player_id
			Success(player_id, email, character_index)
			break
		else:
			print(server.expected_tokens)
			yield(get_tree().create_timer(2), "timeout")
	
	server.VerifyResults(player_id, success)
	if not success:
		waitlist.erase(player_id)
		server.network.disconnect_peer(player_id)

func Success(player_id, email, character_index):
	var instance = server.nexus
	var player_container = player_node.instance()
	
	player_container.email = email
	player_container.name = str(player_id)
	player_container.character_index = character_index
	player_container.instance = instance
	instance.SpawnPlayer(player_container)
	server.CreateHouse(player_container)
	server.player_state_collection[player_id] = {
		"time": OS.get_system_time_msecs(),
		"position": Vector2.ZERO,
		"animation": {
			"animation" : "Idle",
			"direction" : Vector2.ZERO
		},
		"sprite": {
			"rect" : Rect2(Vector2(0,0), Vector2(80,40)),
			"class" : "Apprentice",
			"gear" : {},
			"level" : 0
		},
		"instance" : server.nexus
	}
	HubConnection.AccountData(player_id, player_container, email)

func Fake(position = Vector2(rand_range(-25,25), rand_range(-25,25))):
	var instance = server.nexus
	var bot_container = load("res://Scenes/SupportScenes/BotContainer.tscn").instance()
	var default_account_data = Bots.CreateBot()
	var bot_id = int(ceil(rand_range(11111,91111)))
	
	bot_container.position = position
	bot_container.email = str(rand_range(0,5)).sha256_text()
	bot_container.name =  str(bot_id)
	bot_container.character_index = 0
	bot_container.enemy = {
		"name": "crab",
		"position": bot_container.position,
		"behavior": 1,
		"current_direction" : null,
		"last_position" : Vector2.ZERO,
		"stuck_timer" : 5,
		
		"speed": 3,
		"damage_tracker": {},
		"target": bot_container.position,
		"anchor_position": bot_container.position,
	}
	
	instance.SpawnPlayer(bot_container)
	bot_container.AccountData(default_account_data)
	bot_container.DecorateFake()
	server.player_state_collection[bot_id] = {
		"time": OS.get_system_time_msecs(),
		"position": Vector2.ZERO,
		"animation": {
			"animation" : "Idle",
			"direction" : Vector2.ZERO
		},
		"sprite": {
			"rect" : Rect2(Vector2(0,0), Vector2(80,40)),
			"class" : "Apprentice",
			"gear" : {},
			"level" : 11
		},
		"instance" : server.nexus
	}
	
	server.player_name_by_id[bot_id] = default_account_data.username
	server.player_id_by_name[default_account_data.username] = bot_id
	server.bot_ids[bot_id] = true
	return bot_container


func VerificationExpiration():
	var current_time = OS.get_unix_time()
	var start_time
	
	for player_id in waitlist.keys():
		start_time = waitlist[player_id].time
		if current_time - start_time >= 30:
			var connected_peers = get_tree().get_network_connected_peers()
			waitlist.erase(player_id)
			
			if player_id in connected_peers:
				server.VerifyResults(player_id, false)
				server.network.disconnect_peer(player_id)
	
	
	
	
	
	
