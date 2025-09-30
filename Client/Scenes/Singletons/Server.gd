extends Node

#var url = "ws://159.203.0.78:20200"
var url = "ws://localhost:20200"

var ip_address = "localhost"
var port = 20200

var network = WebSocketClient.new()
var disconnected = true
var client_id
var token

var client_clock = 0
var latency = 0
var timer = 0

onready var root = get_node("/root/SceneHandler")
var disconnected_node = preload("res://Scenes/MainScenes/GameUI/Components/Disconnected/Disconnected.tscn")
var death_node = preload("res://Scenes/MainScenes/GameUI/Components/Death/Death.tscn")
var home_node

func Connect(_token, node):
	network = WebSocketClient.new()
	home_node = node
	token = _token
	
	network.connect_to_url(url, PoolStringArray(), true);
	get_tree().set_network_peer(null)
	get_tree().network_peer = network
	disconnected = false
	
	yield(get_tree().create_timer(1), "timeout")
	
	disconnected = network.get_connection_status() != network.CONNECTION_CONNECTED
	
	if is_instance_valid(home_node) and disconnected:
		home_node.ServerConnection(false)
	elif not is_instance_valid(home_node) and disconnected:
		GameUI.Popup(disconnected_node.instance())
	else:
		network.connect("peer_disconnected", self, "Disconnected")
		network.connect("connection_closed", self, "Disconnected")
		network.connect("connection_error", self, "Disconnected")
		network.connect("server_disconnected", self, "Disconnected")
		client_id = Server.network.get_unique_id()

func Disconnected():
	if not GameHandler.is_dead:
		GameUI.Popup(disconnected_node.instance())

remote func Token():
	rpc_id(1, "ReturnToken", token, GameHandler.character_index)

remote func VerifyResults(success):
	if success:
		home_node.ServerConnection(true)
	else:
		home_node.ServerConnection(false)
		network.disconnect_from_host()

# Generic send
func Send(function, data):
	rpc_id(1, function, data)

func SendEmpty(function):
	rpc_id(1, function)

func SendState(state):
	if not disconnected:
		rpc_unreliable_id(1, "RecievePlayerState", state)
		if network.get_connection_status() == 0:
			disconnected = true
			Disconnected()

remote func RecieveWorldState(world_state):
	GameHandler.instance_node.Update(world_state)

func _physics_process(delta):
	network.poll()
	
	client_clock = OS.get_system_time_msecs() - latency
	timer += 1
	
	if timer % 60 == 0:
		rpc_id(1, "ServerTime", OS.get_system_time_msecs())

remote func ServerTime(server_time, sent_time):
	if abs(latency - (OS.get_system_time_msecs() - server_time)) < 300:
		latency = OS.get_system_time_msecs() - server_time

remote func Tutorial():
	GameUI.game_node = load("res://Scenes/MainScenes/GameUI/Components/Tutorial/Tutorial.tscn")
	GameHandler.tutorial = 1
	GameUI.Popup(GameUI.game_node.instance())

remote func ConfirmUsername(result, username):
	GameHandler.player_node.Name(GameHandler.character.class, username)
	if result == 1:
		GameHandler.tutorial += 1
	GameUI.ConfirmUsername(result)

remote func QuestData(quest):
	GameUI.QuestData(quest)

remote func SetHealth(total, current):
	GameHandler.SetHealth(total, current)

remote func EnemyProjectile(data, enemy_id):
	GameHandler.EnemyProjectile(data, enemy_id)

remote func RemoveEnemyProjectile(projectile_id):
	GameHandler.RemoveProjectile(projectile_id)

remote func PlayerProjectile(data, player_id):
	GameHandler.PlayerProjectile(data, player_id)

remote func AccountData(data):
	Animations.Gold(data.gold)
	GameUI.Account(data)
	AccountHandler.data = data

remote func CharacterData(data):
	GameHandler.character = data
	GameHandler.player_node.SetCharacter(data)
	GameUI.Character(data)

func DamageEnemy(enemy_id, damage):
	rpc_id(1, "DamageEnemy", enemy_id, damage)

func Message(message):
	rpc_id(1, "RecieveMessage", message)

remote func RecieveMessage(message, username, classname = null, id = null, instance_id = null):
	if is_instance_valid(GameHandler.instance_node) and (not instance_id or instance_id == GameHandler.instance_node.name):
		var player = GameHandler.instance_node.GetPlayer(id)
		var enemy = GameHandler.instance_node.GetEnemy(id)
		
		if player:
			GameHandler.instance_node.GetPlayer(id).Message(message)
		
		GameUI.HandleMessage(message, username, classname)

remote func Trade(who):
	var popup_instance = GameUI.trade_request_node.instance()
	GameUI.Popup(popup_instance)
	popup_instance.Set(who)

remote func InitiateTrade(who):
	GameUI.Popup(GameUI.trade_node.instance())

remote func UpdateTrade(data):
	GameUI.UpdateTrade(data)

remote func EndTrade():
	GameUI.Popup(GameUI.game_node.instance())

func EnterInstance(dungeon_id, portal_name):
	Animations.Transition(UtilityFunctions.IdentifierToString(portal_name))
	
	if portal_name == "house": rpc_id(1, "RecieveChatMessage", "/home")
	else: rpc_id(1, "EnterInstance", dungeon_id)

remote func Port(spawnpoint = Vector2.ZERO):
	Animations.Transition("Port")
	GameHandler.Port(spawnpoint)

remote func House(data):
	GameHandler.House(data)

remote func Arena(data):
	GameHandler.Arena(data)

remote func Dungeon(data):
	GameHandler.Dungeon(data)

remote func Island(data, special = null):
	GameHandler.Island(data, special)

remote func Move(pos):
	GameHandler.player_node.position = pos

func UseHelmet():
	rpc_id(1, "UseHelmet")

remote func ReturnChunk(chunk_data, chunk):
	GameHandler.instance_node.GenerateChunk(chunk_data, chunk)

remote func ReturnChunkData(chunk_data, chunk):
	GameHandler.instance_node.UpdateChunk(chunk_data, chunk)

func PlaceBuilding(type, position):
	rpc_id(1, "PlaceBuilding", type, position)

remote func HouseData(data, owner):
	var instance = GameHandler.instance_node
	
	if owner:
		GameUI.HouseData(data)
	if instance.has_method("Tiles"):
		instance.Tiles(data.tiles)

remote func Dialogue(data):
	var dialogue = GameUI.dialogue_node.instance()
	dialogue.next_node = GameUI.game_node
	GameUI.Popup(dialogue)
	dialogue.Subject(data)

remote func Death():
	GameUI.Popup(death_node.instance())
	GameHandler.Death()

remote func Wave(wave):
	Animations.Wave(wave)

remote func KingdomCrushed(ruler_id):
	pass

remote func ReceivePlayerProjectile(projectile_data, player_id):
	if not SettingsHandler.hide_player_shots:
		PlayerProjectile(projectile_data, player_id)

#func UpdateRightJoystick(output):
#	if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player"):
#		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").right_joystick_output = output.normalized()
#func UpdateLeftJoystick(output):
#	if get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player"):
#		get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").left_joystick_output = output.normalized()
#
##Check if vector is within a certain range of player
#func IsWithinRange(_vector, _range = 16):
#	return true if (player_position.distance_to(_vector) <= _range*8) else false
#
#var first_fetch = true
#remote func ReturnServerTime(server_time, client_time):
#	server_delay = (OS.get_system_time_msecs() - client_time) / 2
#	var temp_latency = abs(server_time - client_time - server_delay)
#
#	if first_fetch or abs(latency-temp_latency) < 30:
#		first_fetch = false
#		latency = temp_latency
#
##REALM CLOSE
#remote func RealmClosed(ruler_id, dungeon_name):
#	var ysort = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort")
#	var enemies = ysort.get_node("Enemies")
#
#	Animations.RealmClosed()
#	if ruler_id and enemies.has_node(ruler_id):
#		var enemy = enemies.get_node(ruler_id)
#		var camera = ysort.get_node("player/Camera2D").duplicate(true)
#		camera.set_script(load("res://Scenes/SupportScenes/PlayerCharacter/CameraShake.gd"))
#		enemy.add_child(camera)
#		camera.target = enemy
#
#		var original_instance = current_instance_tree[len(current_instance_tree)-1]
#		while(current_instance_tree[len(current_instance_tree)-1] == original_instance):
#			yield(get_tree().create_timer(0.1), "timeout")
#
#		camera.queue_free()
#		ysort.get_node("player/Camera2D").current = true
#	else:
#		var camera = ysort.get_node("player/Camera2D")
#		camera.target = ysort.get_node("player")
#		var original_instance = current_instance_tree[len(current_instance_tree)-1]
#		while(current_instance_tree[len(current_instance_tree)-1] == original_instance):
#			yield(get_tree().create_timer(0.1), "timeout")
#
#	Animations.Transition(IdentifierToString(dungeon_name))
#	yield(get_tree().create_timer(0.3), "timeout")
#	Animations.RealmClosedEnd()
#
##TUTORIAL
#func DialogueResponse(response):
#	rpc_id(1, "DialogueResponse", response)
#remote func StartTutorial():
#	GameUI.StartTutorial()
#func ChooseUsername(username):
#	rpc_id(1, "ChooseUsername", username)
#remote func ConfirmUsername(result, username):
#	if result:
#		GameUI.account_data.username = username
#		GameUI.get_node("ChooseName").visible = false
#	else:
#		GameUI.get_node("ChooseName/MarginContainer/Container/InputContainer/NameContainter/NameWarning").text = "Name is taken!"
#remote func Dialogue(step):
#	GameUI.get_node("NpcDialogue").StartSubject(step)
#
##OTHER PLAYERS
#func FetchBatchCharacterData(other_players_ids):
#	rpc_id(1, "FetchBatchCharacterData", other_players_ids)
#remote func ReturnBatchCharacterData(characters_data):
#	GameUI.SetNearbyCharacters(characters_data)
#
##TRADE
#remote func RequestTrade(player_name):
#	GameUI.TradeRequest(player_name)
#
#func AcceptTrade(player_name):
#	rpc_id(1, "AcceptTrade", player_name)
#
#remote func StartTrade(player_name):
#	GameUI.Toggle("all")
#	GameUI.is_in_menu = false
#	GameUI.get_node("TradingMenu").other_player_name = player_name
#	GameUI.Toggle("trade")
#
#	if GameUI.is_in_menu == false:
#		GameUI.Toggle("trade")
#
#remote func RecieveTradeData(other_player_inventory, other_player_selection):
#	GameUI.get_node("TradingMenu").SetTradeData(other_player_inventory, other_player_selection)
#remote func OfferWithdrawn():
#	GameUI.get_node("TradingMenu").OfferWithdrawn()
#
#func SelectItem(i):
#	rpc_id(1, "SelectItem", i)
#func DeselectItem(i):
#	rpc_id(1, "DeselectItem", i)
#func AcceptOffer():
#	rpc_id(1, "AcceptOffer")
#func CancelOffer():
#	rpc_id(1, "CancelOffer")
#
#remote func ForceCancelTrade():
#	GameUI.is_in_menu = true
#	GameUI.Toggle("trade")
#remote func OfferAccepted():
#	GameUI.get_node("TradingMenu").OfferAccepted()
#
#remote func FinalizeTrade():
#	GameUI.is_in_menu = true
#	GameUI.Toggle("trade")
#
##INVENTORY/ITEMS
#remote func RecieveAccountData(account_data):
#	GameUI.SetAccountData(account_data)
#remote func RecieveCharacterData(character):
#	var player_node = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player")
#	GameUI.SetCharacterData(character)
#	player_node.SetCharacter(character)
#remote func RecieveQuestData(current_quest_data):
#	GameUI.SetQuest(current_quest_data)
#remote func ShowIndicator(type, amount):
#	var player_node = get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player")
#	player_node.ShowIndicator(type, amount)
#
#func IncreaseStat(stat):
#	rpc_id(1, "IncreaseStat", stat)
#
#
##PLAYER SPAWNING
#remote func SpawnNewPlayer(player_id, spawn_position):
#	return
#	GetCurrentInstanceNode().SpawnNewPlayer(player_id, spawn_position)
#remote func DespawnPlayer(player_id):
#	GetCurrentInstanceNode().DespawnPlayer(player_id)
#
##WORLD SYNCING
#
#remote func ReceivePlayerProjectile(projectile_data, instance_tree, player_id):
#	if player_id == get_tree().get_network_unique_id() or instance_tree != current_instance_tree or Settings.hide_player_shots:
#		return
#
#	var player_node = get_node_or_null("../SceneHandler/"+GetCurrentInstance()+"/YSort/OtherPlayers/"+str(player_id))
#	if player_node:
#		var projectile_dict = player_node.projectile_dict
#		if projectile_dict.has(OS.get_system_time_msecs()):
#			var add = OS.get_system_time_msecs() 
#			while(projectile_dict.has(add)):
#				add += 1
#			projectile_dict[add] = [projectile_data]
#		else:
#			projectile_dict[OS.get_system_time_msecs()] = [projectile_data]
#
#remote func RecieveEnemyProjectile(projectile_data, instance_tree, enemy_id):
#	var enemy_node = get_node_or_null("../SceneHandler/"+GetCurrentInstance()+"/YSort/Enemies/"+str(enemy_id))
#	if instance_tree != current_instance_tree:
#		pass
#	elif enemy_node:
#		enemy_node.ShootProjectile()
#	if GetCurrentInstanceNode().has_node("EnemyPool"):
#		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/EnemyPool").get_children():
#			if child.is_active == false:
#				child.projectile_data = projectile_data
#				child.is_active = true
#				child.Activate()
#				break
#	else:
#		CreatePool(projectile_pool_amount)
#		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/EnemyPool").get_children():
#			if child.is_active == false:
#				child.projectile_data = projectile_data
#				child.is_active = true
#				child.Activate()
#				break
#
#remote func RemoveEnemyProjectile(id, instance_tree):
#	if instance_tree != current_instance_tree:
#		pass
#	if has_node("../SceneHandler/"+GetCurrentInstance()+"/YSort") and GetCurrentInstanceNode().has_node("EnemyPool"):
#		for child in get_node("../SceneHandler/"+GetCurrentInstance()+"/EnemyPool").get_children():
#			if child.projectile_data and child.projectile_data.id == id:
#				child.DeActivate()
#				break
#
#remote func RemoveEnemy(enemy_id):
#	var instance = get_node_or_null("../SceneHandler/"+GetCurrentInstance())
#	var enemy_node = instance.get_node_or_null("/YSort/Enemies/"+str(enemy_id))
#
#	instance.dead_enemies[enemy_id] = true
#	if enemy_node:
#		enemy_node.DeActivate()
#
#func SendPlayerState(player_state):
#	if html_network.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
#		rpc_unreliable_id(1, "RecievePlayerState", player_state)
#
#remote func RecieveWorldState(world_state):
#	if GetCurrentInstanceNode():
#		GetCurrentInstanceNode().UpdateWorldState(world_state)
#
#func UseAbility():
#	rpc_id(1, "UseAbility")
#
##INSTANCES
#func GetCurrentInstanceNode():
#	return get_node("../SceneHandler/"+GetCurrentInstance())
#func GetCurrentInstance():
#	return current_instance_tree[current_instance_tree.size()-1]

#remote func MovePlayer(new_position):
#	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").position = new_position
#
#var last_nexus = 0
#func Nexus():
#	if GameUI.get_node("NpcDialogue").subject == "Final":
#		GameUI.get_node("GameButtons/HomeButton/TutorialArrow").visible = false
#	if "nexus" == GetCurrentInstance() or OS.get_system_time_msecs()-last_nexus < 600:
#		return
#	rpc_id(1, "Nexus")
#	last_nexus = OS.get_system_time_msecs()
#remote func ConfirmNexus(spawnpoint = Vector2.ZERO):
#	Animations.Transition("")
#	yield(get_tree().create_timer(0.3), "timeout")
#	var nexus_instance = nexus.instance()
#	var map_instance = GetCurrentInstanceNode()
#	TransferData({ "Id" : "nexus", "Position" : spawnpoint }, map_instance, nexus_instance)
#	current_instance_tree = ["nexus"]
#
#
#remote func UpdateHouseData(house_data):
#	GameUI.account_data.home = house_data
#	GameUI.get_node("Building").SetHouseData(house_data)
#
#remote func UpdateHouseTiles(tiles):
#	var house_instance = GetCurrentInstanceNode()
#	house_instance.UpdateTiles(tiles)
#

#
#
#remote func ShowExpIndicator(xp):
#	get_node("../SceneHandler/"+GetCurrentInstance()+"/YSort/player").ShowExpIndicator(xp)
#
##ENEMIES
#
#remote func SetHealth(max_health, current_health):
#	GameUI.ChangeHealth(max_health, current_health)
#
#func NPCHit(enemy_id, damage):
#	rpc_id(1, "NPCHit", enemy_id, damage)
#
#func CreatePool(amount):
#	print("CREAITINGNG")
#	var enemy_pool = projectile_pool.instance()
#	var player_pool = projectile_pool.instance()
#	enemy_pool.name = "EnemyPool"
#	player_pool.name = "PlayerPool"
#
#	GetCurrentInstanceNode().add_child(enemy_pool)
#	GetCurrentInstanceNode().move_child(enemy_pool, 0)
#	GetCurrentInstanceNode().add_child(player_pool)
#	GetCurrentInstanceNode().move_child(player_pool, 0)
#	for i in range(amount):
#		enemy_pool.add_child(enemy_projectile.instance())
#		player_pool.add_child(player_projectile.instance())
#
