extends Node

onready var server = get_node("/root/Server")

var chat_messages = []
var mute_list = {}

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

func Help(player_id):
	var commands = [
		"Commands:",
		"/help (command list)",
		"/home (go to your house)",
		"/home username (go to username's house if you are allowed)",
		"/players (list of online players)",
		"/trade username (send trade offer to username)",
		"/teleport username (teleport to username)"
	]
	for command in commands:
		server.rpc_id(player_id, "RecieveMessage", command, "System")

func PlayersOnline(player_id):
	var connected_players = server.get_tree().get_network_connected_peers()
	var username_by_id = server.player_name_by_id
	var result = ""
	var count = 0
	
	for id in connected_players: if id in username_by_id:
			count += 1
			if count < 10:
				result += username_by_id[id] + ", "
	if count >= 10:
		result += "..."
	
	server.rpc_id(player_id, "RecieveMessage", "There are %d players online: %s" % [count, result], "System")

func EnterHouse(player_id, selected_player_name):
	var selected_player_id = FindPlayerByName(selected_player_name)
	
	if VerifyPlayer(selected_player_id):
		server.EnterHouse(player_id, selected_player_id)
	else:
		server.Message(player_id, "error", "Invalid username: %s" % [selected_player_name])

func Teleport(player_id, instance, player_container, message):
	var selected_player_name = message[1]
	var selected_player_id = FindPlayerByName(selected_player_name)
	
	if VerifyPlayer(selected_player_id):
		var state = server.player_state_collection[selected_player_id]
		var selected_player_instance = state.instance
		var selected_player_position = state.position
		var cooldown = OS.get_system_time_secs() - player_container.last_teleported
		var valid_cooldown = cooldown < 5
		
		if valid_cooldown:
			server.Message(player_id, "system", "Teleport on cooldown, wait " + str(5 - cooldown) + " more seconds.")
		elif instance == selected_player_instance:
			player_container.last_teleported = OS.get_system_time_secs()
			server.player_state_collection[player_id].position = selected_player_position
			server.rpc_id(player_id, "Move", selected_player_position)
			server.Message(player_id, "system", "You have teleported to " + selected_player_name)
		else:
			server.Message(player_id, "system", selected_player_name + " is in a different island.")
	else:
		server.Message(player_id, "error", "Couldn't find %s" % [selected_player_name])

func Trade(player_id, player_container, message, player_name):
	var selected_player_name = message[1]
	var selected_player_id = FindPlayerByName(selected_player_name)
	
	if VerifyPlayer(selected_player_id) and player_id != selected_player_id:
		var state = server.player_state_collection[selected_player_id]
		var selected_player_instance = state.instance
		var selected_player_position = state.position
		
		if player_container.position.distance_to(selected_player_position) > 32*8:
			server.rpc_id(player_id, "RecieveMessage", "%s is too far away" % [selected_player_name], "System")
		else:
			server.rpc_id(player_id, "RecieveMessage", "You have requested a trade with %s" % [selected_player_name], "System")
			server.rpc_id(selected_player_id, "Trade", player_name)
	else:
		server.rpc_id(player_id, "RecieveMessage", "Couldn't find %s" % [selected_player_name], "SystemERROR")

func CloseRealm(instance):
	#rpc_id(player_id, "MovePlayer", instance_node.enemy_list[instance_node.ruler_id]["position"]+Vector2(0,50))
	yield(get_tree().create_timer(2), "timeout")
	instance.enemy_list[instance.ruler_id]["health"] = 0

func CloseAllRealms(instance):
	for node in instance.get_children():
		if "island" in node.name and node.ruler != "pumpkin_tyrant" and node.ruler_id:
			node.enemy_list[node.ruler_id]["health"] = 0

func Roll(player_id, player_container, instance, message):
	var which = message[1]
	var amount = int(message[2])
	
	for i in range(amount):
		instance.CalculateLootPool({
			"position" : player_container.position, 
			"name" : which, 
			"damage_tracker" : { player_id : 1 }, 
			"max_health" : 1 
		}, 1)

func Bot(player_id, player_container, instance, message):
	var multiple = len(message) > 1 and int(message[1])
	if multiple:
		var amount = int(message[1])
		
		for i in range(amount):
			var container = PlayerVerification.Fake(player_container.position)
			var bot_id = int(container.name)
			
			container.GiveEffect("invincible", 99999)
			container.position = player_container.position
			
			server.ForcedPort(bot_id)
			server.ForcedEnterInstance(instance, bot_id)
			instance.UpdatePlayer(str(bot_id), {
				"time" : OS.get_system_time_msecs(),
				"position" : container.position,
				"animation" : {
					"animation" : "Idle",
					"direction" : Vector2.ZERO },
					"sprite" : {
						"rect" : Rect2(Vector2(0,0), Vector2(80,40)),
						"class" : "Apprentice", 
						"colors" : {
							"ColorParams" : {},
							"TextureParams" : {}
						}
					}
				}
			)
	else:
		server.rpc_id(player_id, "RecieveMessage", "Error spawning bots", "SystemERROR")

func Dungeon(player_id, instance, player_container, message):
	var dungeon = message[1]
	
	if dungeon in ServerData.dungeons.keys():
		instance.OpenPortal(dungeon, player_container.position)
		server.Message(player_id, "system", "You have opened a " + message[1])
	else:
		server.Message(player_id, "error", "Error opening dungeon")

func Spawn(player_id, instance, player_container, message):
	var enemy = message[1]
	var valid_enemy = enemy in ServerData.enemies
	var multiple_enemies = len(message) > 2 and int(message[2])
	
	if valid_enemy and multiple_enemies:
		var amount = int(message[2])
		for i in range(amount):
			instance.SpawnEnemy(enemy, player_container.position - instance.position)
		server.rpc_id(player_id, "RecieveMessage", "You have spawned " + str(amount) + " " + enemy + "s", "System")
	elif valid_enemy:
		instance.SpawnEnemy(message[1], player_container.position - instance.position)
		server.rpc_id(player_id, "RecieveMessage", "You have spawned a " + message[1], "System")
	else:
		server.rpc_id(player_id, "RecieveMessage", "Error spawning enemy", "SystemERROR")

func Loot(player_id, instance, player_container, message):
	var valid = int(message[1]) in ServerData.items
	var item = ServerData.GetItem(int(message[1]))
	
	if valid and (item.tier == "UT" or int(item.tier) > 1):
		instance.SpawnLootBag([
			{
				"item" : int(message[1]),
				"id" : server.generate_unique_id()
			}], 
			player_id, 
			player_container.position
		)
		server.rpc_id(player_id, "RecieveMessage", "You have looted a " + message[1], "System")
	elif valid:
		instance.SpawnLootBag([
			{
				"item" : int(message[1]),
				"id" : server.generate_unique_id()
			}
			], 
			null, 
			player_container.position
		)
		server.rpc_id(player_id, "RecieveMessage", "You have looted a " + message[1], "System")
	else:
		server.rpc_id(player_id, "RecieveMessage", "Invalid loot id", "SystemERROR")

func RecieveMessage(message, player_id):
	var instance = server.player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	var player_name = server.player_name_by_id[player_id]
	
	if player_container and len(message) >= 1:
		var admin = "admin" in player_container.account_data
		var message_words = message.split(" ")
		var length = len(message_words)
		
		var home_alternatives = [
			"/home",
			"/house",
			"/h", 
			"/abode", 
			"/domacile"
		]
		var players_online_alternatives = [
			"/players",
			"/online",
			"/characters",
			"/p",
			"/c"
		]
		var teleport_alternatives = [
			"/tp",
			"/teleport",
		]
		
		if message[0] == "/":
			if message_words[0] == "/help":
				Help(player_id)
			elif message_words[0] in players_online_alternatives:
				PlayersOnline(player_id)
			elif message_words[0] in home_alternatives and len(message_words) == 1:
				EnterHouse(player_id, player_name)
			elif message_words[0] in home_alternatives:
				EnterHouse(player_id, message_words[1])
			elif message_words[0] in teleport_alternatives:
				Teleport(player_id, instance, player_container, message_words)
			elif message_words[0] == "/trade":
				Trade(player_id, player_container, message_words, player_name)
		if message[0] == "/" and admin:
			print(message_words[0] == "/achievement")
			if message_words[0] == "/mute":
				mute_list[player_name] = true
			elif message_words[0] == "/closerealm":
				CloseRealm(instance)
			elif message_words[0] == "/closeallrealms":
				CloseAllRealms(instance)
			elif message_words[0] == "/roll" and message_words.size() > 2:
				Roll(player_id, player_container, instance, message)
			elif message_words[0] == "/giveitem":
				player_container.GiveItem(int(message_words[1]))
			elif message_words[0] == "/damage":
				player_container.DealDamage(int(message_words[1]), "System")
			elif message_words[0] == "/bot":
				Bot(player_id, player_container, instance, message_words)
			elif message_words[0] == "/class" and message_words[1] in player_container.account_data.classes:
				player_container.GetAchievement("Unlock " + message_words[1])
			elif message_words[0] == "/achievement":
				var which = message.lstrip("/achievement ")
				if which in ServerData.achievements: player_container.GetAchievement(which)
			elif message_words[0] == "/exp" and int(message_words[1]):
				player_container.AddExp(int(message_words[1]), "System", 1)
			elif message_words[0] == "/invincible":
				player_container.GiveEffect("invincible", 99999)
			elif message_words[0] == "/d":
				Dungeon(player_id, instance, player_container, message_words)
			elif message_words[0] == "/spawn" and length > 1:
				Spawn(player_id, instance, player_container, message_words)
			elif message_words[0] == "/loot" and length == 2:
				Loot(player_id, instance, player_container, message_words)
			elif message_words[0] == "/max" and message_words.size() == 1:
				player_container.Max()
			elif message_words[0] == "/hypermax" and message_words.size() == 1:
				player_container.Max(true)
		elif message[0] != "/" and not player_name in mute_list:
			chat_messages.append({
				"sender" : player_name,
				"timestamp" : OS.get_system_time_msecs(),
				"fake" : false,
			})
			var filters = "rape nigger nigga nigg chigger chigga fuck bitch pussy vagina dick cum cock sex anal shit murder hitler nazi abuse abusive bitch bullshit cock fucking moron nigger nigga n@gg n!g retard shit slut stupid whore fag faggot chigger china tranny"
			for filter in filters.split(" "):
				message = message.replace(filter, "****")
				message = message.replace(filter.to_upper(), "****")
			
			server.rpc("RecieveMessage", message, player_name, player_container.character.class, player_container.name)
