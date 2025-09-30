extends Node

var port = 20200
var network = WebSocketServer.new()
onready var nexus = get_node("Instances/port")

var expected_tokens = {}
var instance_positions = {
	Vector2.ZERO : true
}

var player_instance_tracker = {}
var player_state_collection = {}
var player_name_by_id = {}
var player_id_by_name = {}

func _ready():
	randomize()
	VisualServer.render_loop_enabled = false
	Start()
	GameplayLoop.CreateIslandTemplate()
	#GameplayLoop.CreateIslandTemplate()
	#GameplayLoop.CreateIslandTemplate()
	#GameplayLoop.CreateIslandTemplate(Vector2(502,502), "halloween")
	#GameplayLoop.CreateIslandTemplate(Vector2(802,802), "tundra")
	
	#Open realm
	#SpawnEnemy("raa'sloth", ["nexus"], Vector2(0,0))
	#nexus.OpenPortal("island", ["nexus"], nexus.GetBoatSpawnpoints(), Vector2(750,750), "salazar")
	#var island_id = null
	#nexus.OpenPortal("rocky_cave", (Vector2(14*8, 18*8) + Vector2(4,4)))
	#nexus.OpenPortal("rocky_cave", (Vector2(14*8, 18*8) + Vector2(4,4)))
	#nexus.OpenPortal("rocky_cave", (Vector2(14*8, 18*8) + Vector2(4,4)))
	
	var island_id = nexus.OpenPortal("island", nexus.GetBoatSpawnpoints(), Vector2(750,750), "oranix")
	nexus.OpenPortal("island", nexus.GetBoatSpawnpoints(), Vector2(750,750), "vajira")
	nexus.OpenPortal("island", nexus.GetBoatSpawnpoints(), Vector2(750,750), "raa'sloth")
	#nexus.OpenPortal("island", Vector2(-19*8, -37*8), Vector2(750,750), null)
	#nexus.SpawnEnemy("frozen_monolith", Vector2(14*8, 18*8))
	#nexus.SpawnEnemy("og_the_treacherous", Vector2(14*8, 18*8))
	nexus.OpenPortal("house", (Vector2(0*8, 15*8) + Vector2(4,4)))
	nexus.SpawnNPC("arena_master", (Vector2(-11*8, 17*8) + Vector2(4,4)))
	nexus.SpawnNPC("tutorial_master", (Vector2(-8*8, -6*8) + Vector2(4,4)))
	nexus.SpawnNPC("old_fisherman", (Vector2(17*8, -2*8) + Vector2(4,4)))
	nexus.SpawnNPC("green_oracle", (Vector2(14*8, 18*8) + Vector2(4,4)))
	#nexus.SpawnEnemy("oracle_placeholder", Vector2(14*8, 18*8))
#	#nexus.OpenPortal("special_island", ["nexus"], nexus.GetBoatSpawnpoints(), Vector2(502,502), "pumpkin_tyrant", "halloween")
#
	for i in range(0):
		var container = PlayerVerification.Fake()
		var bot_id = int(container.name)
		var state = player_state_collection[bot_id]
		
		container.position = ForcedEnterInstance(island_id, bot_id)
		var island = container.instance
		island.SpawnPlayer(container)
		island.GetIslandChunk(island.CalculateChunk(island.player_list[container.name].position))
		container.GiveEffect("invincible", 99999)

#Update connected players
var clock_sync_timer = 0
var bot_ids = {}
func _physics_process(delta):
	clock_sync_timer += 1
	if clock_sync_timer >= 60:
		var network_connected_peers = get_tree().get_network_connected_peers()
		for instance_tree in player_instance_tracker.keys():
			for id in player_instance_tracker[instance_tree]:
				if not network_connected_peers.has(id) and not bot_ids.has(id):
					player_instance_tracker[instance_tree].erase(id)

func _process(delta):
	if network.is_listening(): network.poll()

func Start():
	network.listen(port, PoolStringArray(), true)
	
	get_tree().set_network_peer(network);
	get_tree().connect("network_peer_connected", self, "_Peer_Connected")
	get_tree().connect("network_peer_disconnected", self, "_Peer_Disconnected")
	
func _Peer_Connected(id):
	print("User has connected")
	PlayerVerification.Start(id)

func _Peer_Disconnected(id):
	print("User has disconnected")
	
	var valid_player = (
		id in player_state_collection
		and is_instance_valid(player_state_collection[id].instance)
		and player_state_collection[id].instance.GetPlayer(id)
	)
	
	if valid_player:
		var instance = player_state_collection[id].instance
		var player_container = instance.GetPlayer(id)
		var email = player_container.email
		
		if player_container.character:
			for stat in ["health", "attack", "defense", "speed", "dexterity", "vitality"]:
				if player_container.stat_buffs.has(stat):
					player_container.GiveBuff(0, stat, 0)
			
			DeleteHouse(id)
		
		if email in PlayerVerification.verified:
			PlayerVerification.verified.erase(email)
		if player_container.account_data:
			HubConnection.UpdateAccountData(player_container.email, player_container.account_data)
		
		instance.RemovePlayer(id)
		player_container.queue_free()
		player_state_collection.erase(id)
		rpc_id(0, "DespawnPlayer", id)

func VerifyPlayer(player_id):
	return (
		player_id
		and player_id in player_state_collection
		and player_state_collection[player_id].instance.GetPlayer(player_id)
	)

func GetPlayer(player_id):
	var instance = player_state_collection[int(player_id)].instance
	return instance.GetPlayer(player_id)

remote func ServerTime(sent_time):
	rpc_id(get_tree().get_rpc_sender_id(), "ServerTime", OS.get_system_time_msecs(), sent_time)

func Tutorial(player_container):
	var house = player_container.GetHouse()
	var player_id = int(player_container.name)
	
	if house:
		var tutorial = house.OpenPortal("tutorial_entrance", Vector2.ZERO)
		
		if is_instance_valid(tutorial):
			ForcedEnterInstance(tutorial, player_id)
			rpc_id(player_id, "Tutorial")

remote func ChooseUsername(username):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	
	if player_container.account_data.username == "[unset]":
		HubConnection.ConfirmUsername(username, player_id)
	else:
		ConfirmUsername(1, player_container.account_data.username, player_id)
	
func ConfirmUsername(result, username, player_id):
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	
	if result == 1:
		player_name_by_id[player_id] = username
		player_id_by_name[username] = player_id
		player_container.account_data.username = username
		player_container.GetHouse().AccountData(player_container.account_data)
		instance.player_list[str(player_id)].name = username
	
	rpc_id(player_id, "ConfirmUsername", result, username)

remote func DoneTutorial():
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	player_container.account_data.tutorial = true

remote func Dialogue(response):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	
	var responses = {
		"Classes/Ascension" : {
			"text" : ["Ascension allows you to increase your stats even further beyond level 10...", "To ascend, you need to consume ascension stones.", "Each tier of class has a max ascension limit:", "Tier 1 (apprentice) has a cap of 5 stones...", "Tier 2 has a cap of 50...", "And tier 3 has a cap of 75.", "To evolve you have to do certain quests like killing 3000 enemies...","you can find hints underneath each of the 3 evolutions in the classes page.", "To see the classes page click on the helmet button under the dropdown in the top right."],
			"character_rect" : Vector2(0,0),
		},
		"Gameplay" : {
			"text" : ["You can sail on boats to different kingdoms, which have been overtaken by monsters...", "By defeating them you can get items and level up!", "Each kingdom has a ruler at the center of the map which you need to defeat.", "If you are a beginner, I recommend following your quest compass around...", "It's the dark arrow in the top left pointing where you should go. Good luck!"],
			"character_rect" : Vector2(0,0),
		},
		"Death" : {
			"text" : ["When you die in game you will lose your character permanently...", "Each character can be revived for gold, but only once.", "I recommend storing valuable items in your home for when you die.", "Just press the home button in the bottom right to go to your house!."],
			"character_rect" : Vector2(0,0),
		},
		"I'll keep an eye out" : {
			"text" : ["I appreciate it, I can't remember the last good meal I had."],
			"character_rect" : Vector2(60,0),
		},
		"No Thanks" : {
			"text" : ["Whats that? No thanks? Suit yourself."],
			"character_rect" : Vector2(40,0),
		}
	}

	if VerifyPlayer(player_id):
		var time_tracker = player_container.account_data.time_tracker
		var time = OS.get_datetime()
		var day = time.day
		var month = time.month
		
		if response == "Daily Arena":
			time_tracker[response] = time
			ForcedEnterInstance(CreateArena(player_id, player_container, "daily"), player_id)
		elif response == "Daily Arena":
			rpc_id(player_id, "Dialogue", {
				"text" : ["You've already done this arena recently...", "What, do you think I'm made of money?"],
				"character_rect" : Vector2(20,0),
			})
		elif response == "Monthly Arena" and (not time_tracker.has(response) or (month != time_tracker[response]["month"])):
			time_tracker[response] = time
			ForcedEnterInstance(CreateArena(player_id, player_container, "monthly"), player_id)
		elif response == "Monthly Arena":
			rpc_id(player_id, "Dialogue", {
				"text" : ["You've already done this arena recently...", "What, do you think I'm made of money?"],
				"character_rect" : Vector2(20,0),
			})
		elif response == "I have one!":
			var inventory = player_container.character.inventory
			var i = -1
			
			for raw_item in inventory:
				i += 1
				if raw_item and raw_item.item == 14:
					player_container.UseItem(i, true)
					rpc_id(player_id, "Dialogue", {
						"text" : ["This is gonna be tasty...", "Well you held up your end of the bargain, so I'll sail you to my old friend's kingdom...", "Don't cause to much chaos, alright?"],
						"character_rect" : Vector2(60,0),
					})
					return
			rpc_id(player_id, "Dialogue", {
				"text" : ["You liar!", "I can smell blue tuna from a mile away, and you don't have it."],
				"character_rect" : Vector2(60,0),
			})
		elif response == "Yeah Sure":
			if player_container.account_data.gold >= 100:
				player_container.account_data.gold -= 100
				player_container.character.used_ascension_stones = 0

				var stat_coefficient = min(player_container.character.level, 20)
				var inverse_character_map = {}
				var character_map = {
					"Apprentice" : [0],

					"Noble" : [0,0],
					"Nomad" : [0,1],
					"Scholar" : [0,2],

					"Knight": [0,0,0],
					"Paladin": [0,0,1],
					"Marauder": [0,0,2],

					"Ranger": [0,1,0],
					"Sentinel": [0,1,1],
					"Scout": [0,1,2],

					"Magician": [0,2,0],
					"Druid": [0,2,1],
					"Warlock": [0,2,2],
				}
				for classname in character_map.keys():
					var value = character_map[classname]
					inverse_character_map[value] = classname

				player_container.character.stats = {
					"health" : 20 * stat_coefficient,
					"attack" : 1 * stat_coefficient,
					"defense" : 0,
					"speed" : 0.5 * stat_coefficient,
					"dexterity" : 1 * stat_coefficient,
					"vitality" : 1 * stat_coefficient,
				}

				var class_key = character_map[player_container.character.class].duplicate()
				while len(class_key) > 0:
					var new_character_name = inverse_character_map[class_key]
					var new_character_stats = ServerData.GetCharacter(new_character_name).bonus_stats

					for stat in player_container.character.stats.keys():
						player_container.character.stats[stat] += new_character_stats[stat]
					class_key.pop_back()

				CharacterData(player_id, player_container.character)
				rpc_id(player_id, "Dialogue", {
					"text" : ["Whats that? It worked? Be more careful what stats you increase this time..."],
					"character_rect" : Vector2(40,0),
				})
				return
			rpc_id(player_id, "Dialogue", {
				"text" : ["Whats that? Your broke?", "Bahaha! Come back when you get some money bottomfeeder."],
				"character_rect" : Vector2(40,0),
			})
		elif response in responses:
			rpc_id(player_id, "Dialogue", responses[response])

#BUILDING
remote func ToggleState():
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	var house = player_container.GetHouse()
	
	if instance == house and house.player_id == player_id:
		house.ToggleState()

remote func RemoveBuilding(position):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	var house = player_container.GetHouse()
	
	if instance == house and house.player_id == player_id:
		house.RemoveBuilding(position)

remote func PlaceBuilding(type, position):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	var house = player_container.GetHouse()
	
	if instance == house and house.player_id == player_id:
		house.PlaceBuilding(type, position)

remote func Craft(type):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	var house = player_container.GetHouse()
	
	if instance == house and house.player_id == player_id:
		house.Craft(type)

#TRADE
remote func AcceptTrade(player_name):
	var player_id = get_tree().get_rpc_sender_id()
	Trade.Accept(player_name, player_id)

func UpdateTrade(player_id, data):
	rpc_id(player_id, "UpdateTrade", data)

remote func OfferWithdrawn(player_id1, player_id2):
	rpc_id(int(player_id1), "OfferWithdrawn")
	rpc_id(int(player_id2), "OfferWithdrawn")

remote func Offer(offer):
	var player_id = get_tree().get_rpc_sender_id()
	GetPlayer(player_id).Offer(offer)

remote func AcceptOffer():
	var player_id = get_tree().get_rpc_sender_id()
	GetPlayer(player_id).AcceptOffer()

remote func CancelOffer():
	var player_id = get_tree().get_rpc_sender_id()
	GetPlayer(player_id).CancelOffer()

func EndTrade(player_id_1, player_id_2):
	rpc_id(player_id_1, "EndTrade")
	rpc_id(player_id_2, "EndTrade")
	Message(player_id_1, "error", "Invalid trade")
	Message(player_id_2, "error", "Invalid trade")

func DoneTrade(player_id_1, player_id_2):
	rpc_id(player_id_1, "EndTrade")
	rpc_id(player_id_2, "EndTrade")
	Message(player_id_1, "system", "Trade successful")
	Message(player_id_2, "system", "Trade successful")

#INVENTORY/ITEMS
remote func FetchPlayerData(email):
	var player_id = get_tree().get_rpc_sender_id()
	var player_data = get_parent().get_node(str(player_id)).getPlayerData()
	rpc_id(player_id, "ReturnPlayerData", player_data)

remote func UseItem(index):
	Items.UseItem(index, get_tree().get_rpc_sender_id())

remote func EquipItem(index):
	Items.EquipItem(index, get_tree().get_rpc_sender_id())

remote func SwapItem(data):
	var to_data = data[0]
	var from_data = data[1]
	Items.SwapItem(to_data, from_data, get_tree().get_rpc_sender_id())

remote func DropItem(data):
	Items.DropItem(data, get_tree().get_rpc_sender_id())

remote func IncreaseStat(stat):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	player_container.IncreaseStat(stat)

remote func UseHelmet():
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	player_container.UseHelmet()

func RecieveFakePlayerState(player_id, player_state):
	if player_id in player_state_collection:
		var instance = player_state_collection[player_id].instance
		player_state.instance = instance
		player_state_collection[player_id] = player_state
		instance.UpdatePlayer(player_id, player_state)

remote func RecievePlayerState(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	
	if player_id in player_state_collection:
		if player_state_collection[player_id].time <  player_state.time:
			var instance = player_state_collection[player_id].instance
			player_state.instance = instance
			player_state_collection[player_id] = player_state
			instance.UpdatePlayer(player_id, player_state)

func SendWorldState(id, world_state):
	if int(id) in get_tree().get_network_connected_peers():
		rpc_unreliable_id(int(id), "RecieveWorldState", world_state)

#TOKENS
func _on_TokenExpiration_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if expected_tokens == {}:
		pass
	else:
		for i in range(expected_tokens.keys().size() -1, -1, -1):
			token_time = int(expected_tokens.keys()[i].right(64))
			if current_time - token_time >= 30:
				expected_tokens.keys().remove(i)

func _on_VerificationExpiration_timeout():
	PlayerVerification.VerificationExpiration()

func Token(player_id):
	rpc_id(player_id, "Token")

remote func ReturnToken(token, character_index):
	var player_id = get_tree().get_rpc_sender_id()
	if not token:
		print("No token")
		network.disconnect_peer(player_id)
		return
	PlayerVerification.Verify(player_id, token, character_index)

func VerifyResults(player_id, result):
	print("Verification " + str(result))
	rpc_id(player_id, "VerifyResults", result)
	
	if result: rpc_id(0, "SpawnPlayer", player_id, Vector2(79, 56))

func QuestData(player_id, current_quest_data):
	if int(player_id) in get_tree().get_network_connected_peers():
		rpc_unreliable_id(player_id, "QuestData", current_quest_data)

func CharacterData(player_id, character):
	rpc_unreliable_id(player_id, "CharacterData", character)

func AccountData(player_id, account_data):
	if int(player_id) in get_tree().get_network_connected_peers():
		rpc_id(player_id, "AccountData", account_data)

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction

func SendFakePlayerProjectile(projectile_data, player_id):
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	if not player_container or not "weapon" in player_container.gear: return
	
	var weapon = ServerData.GetItem(player_container.gear.weapon.item)
	if len(weapon.projectiles) <= projectile_data.index:
		return
	
	var projectile = weapon.projectiles[projectile_data.index]
	projectile_data.direction = OffsetProjectileAngle(projectile_data.direction, projectile.offset)
	projectile_data.merge({
		"projectile" : projectile.projectile,
		"tile_range" : projectile.tile_range,
		"piercing": projectile.piercing,
		"formula": projectile.formula,
		"speed": projectile.speed,
		"size": projectile.size,
	})
	
	for id in player_instance_tracker[instance]: if player_id != id:
		if player_state_collection[id].position.distance_to(player_state_collection[player_id].position) < 16*8:
			rpc_id(id, "ReceivePlayerProjectile", projectile_data, player_id)

remote func SendPlayerProjectile(projectile_data):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	var player_container = instance.GetPlayer(player_id)
	if not player_container or not "weapon" in player_container.gear: return
	
	var weapon = ServerData.GetItem(player_container.gear.weapon.item)
	if len(weapon.projectiles) <= projectile_data.index:
		return
	
	var projectile = weapon.projectiles[projectile_data.index]
	projectile_data.direction = OffsetProjectileAngle(projectile_data.direction, projectile.offset)
	projectile_data.merge({
		"projectile" : projectile.projectile,
		"tile_range" : projectile.tile_range,
		"piercing": projectile.piercing,
		"formula": projectile.formula,
		"speed": projectile.speed,
		"size": projectile.size,
	})
	
	for id in player_instance_tracker[instance]: if player_id != id:
		if player_state_collection[id].position.distance_to(player_state_collection[player_id].position) < 16*8:
			rpc_id(id, "ReceivePlayerProjectile", projectile_data, player_id)

func EnemyProjectile(projectile_data, instance, enemy_id):
	var peers = get_tree().get_network_connected_peers()
	
	for player_id in player_instance_tracker[instance]:
		if player_id in peers:
			rpc_id(player_id, "EnemyProjectile", projectile_data, enemy_id)

func RemoveEnemyProjectile(projectile_id, instance):
	for player_id in player_instance_tracker[instance]:
		if int(player_id) in get_tree().get_network_connected_peers():
			rpc_id(player_id, "RemoveEnemyProjectile", projectile_id)

remote func DamageEnemy(enemy_id, damage):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	var which_achievement
	
	enemy_id = str(enemy_id)
	player_id = str(player_id)
	if not player_container: return
	
	if player_container.gear.weapon:
		var weapon_type = ServerData.GetItem(player_container.gear.weapon.item).type
		if weapon_type == "Staff": which_achievement = "staff_projectiles"
		elif weapon_type == "Sword": which_achievement = "sword_projectiles"
		elif weapon_type == "Bow": which_achievement = "bow_projectiles"
	
	if enemy_id in instance.enemy_list:
		var enemy = instance.enemy_list[enemy_id]
		var total_damage = ceil(damage / (1 + (ServerData.GetEnemy(enemy.name).defense / 100)))
		
		if "invincible" in enemy.effects:
			total_damage = 0
		
		enemy.health -= total_damage
		var damage_tracker = instance.enemy_list[enemy_id].damage_tracker
		if not player_id in damage_tracker: damage_tracker[player_id] = 0
		damage_tracker[player_id] += total_damage
		
		player_container.UpdateStatistics("projectiles_landed", 1)
		player_container.UpdateStatistics(which_achievement, 1)

#INSTANCES
remote func Port():
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	
	if instance.arena:
		if player_container.health > 0:
			player_container.DealDamage(9999, "Gladius")
	else:
		rpc_id(player_id, "Port")
		
		instance.RemovePlayer(player_id)
		nexus.SpawnPlayer(player_container)
		
		player_state_collection[player_id] = {
			"time": OS.get_system_time_msecs(),
			"position": Vector2.ZERO,
			"animation": "Idle",
			"instance": nexus
		}

func ForcedPort(player_id, spawnpoint = Vector2.ZERO):
	var instance = player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	
	rpc_id(player_id, "Port", spawnpoint)
	
	instance.RemovePlayer(player_id)
	nexus.SpawnPlayer(player_container)
	
	player_state_collection[player_id] = {
		"time": OS.get_system_time_msecs(),
		"position": Vector2.ZERO,
		"animation": "Idle",
		"instance": nexus
	}

func EnterHouse(player_id, house_player_id):
	var house_id = "house " + str(house_player_id)
	var house = nexus.get_node(house_id)
	
	if not house.RequestEntry(player_name_by_id[player_id]):
		Message(player_id, "error", "Access not permitted by owner!")
		return
	
	var instance = player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	
	instance.RemovePlayer(player_id)
	house.SpawnPlayer(player_container)
	
	player_state_collection[player_id] = {
		"time": OS.get_system_time_msecs(),
		"position": Vector2.ZERO,
		"animation": "Idle",
		"instance": house
	}
	rpc_id(player_id, "House", {
		"name" : player_name_by_id[house_player_id],
		"id" : house_id, 
		"tiles" : house.tiles, 
		"position" : Vector2(12*8, 12*8)
	})

func CreateArena(player_id, player_container, type):
	var arena_id = "arena " + str(player_id)
	var arena_instance = load("res://Scenes/SupportScenes/Arena/Arena.tscn").instance()
	arena_instance.name = arena_id
	arena_instance.arena_type = type
	arena_instance.player_id = player_id
	arena_instance.player_container = player_container
	arena_instance.position = Instances.GetFreeInstancePosition()
	
	nexus.add_child(arena_instance)
	return arena_instance

func CreateHouse(player_container):
	var house_id = "house " + player_container.name
	var house_instance = load("res://Scenes/SupportScenes/Housing/House.tscn").instance()
	house_instance.name = house_id
	house_instance.player_id = int(player_container.name)
	house_instance.player_container = player_container
	house_instance.position = Instances.GetFreeInstancePosition()
	
	nexus.add_child(house_instance)

func DeleteHouse(player_id):
	if bot_ids.has(player_id): return
	
	var house_id = "house " + str(player_id)
	var house = nexus.get_node_or_null(house_id)
	
	for _player_id in player_instance_tracker[house].duplicate():
		ForcedPort(_player_id)
		Message(_player_id, "warning", player_name_by_id[player_id] + "'s house has been closed.")
	
	player_instance_tracker.erase(house)
	house.SaveData()
	house.queue_free()

func ForcedEnterInstance(instance, player_id):
	var current_instance = player_state_collection[player_id].instance
	var player_container = current_instance.GetPlayer(player_id)
	var spawnpoint
	
	if is_instance_valid(player_container):
		player_container.GiveEffect("invincible", 5)
		current_instance.RemovePlayer(player_id)
		instance.SpawnPlayer(player_container)
		
		if instance.arena:
			spawnpoint = Vector2.ZERO
			
			rpc_id(player_id, "Arena", {
				"name": instance.arena_type.capitalize() + " Arena",
				"id": instance.name,
				"position": spawnpoint
			})
		elif not "island" in instance.name and "dungeon" in instance.name:
			spawnpoint = instance.GetMapSpawnpoint()
			
			rpc_id(player_id, "Dungeon", {
				"map": instance.map,
				"name": instance.dungeon_name,
				"id": instance.name,
				"room_size": instance.room_size,
				"position": spawnpoint
			})
		elif "island" in instance.name:
			spawnpoint = instance.GetMapSpawnpoint()
			
			rpc_id(player_id, "Island", {
				"name": instance.ruler,
				"id": instance.name,
				"position": instance
			}, instance.which if "special" in instance.name else null)
		
		player_state_collection[player_id] = {
			"time": OS.get_system_time_msecs(),
			"position": spawnpoint,
			"animation": {
				"animation" : "Idle",
				"direction" : Vector2.ZERO
			},
			"instance": instance
		}
		CharacterData(player_id, player_container.character)
		return spawnpoint

remote func EnterInstance(instance_id):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[int(player_id)].instance
	var player_container = instance.GetPlayer(player_id)
	
	if instance_id and instance.has_node(instance_id):
		var new_instance = instance.get_node(instance_id)
		var spawnpoint
		
		player_container.GiveEffect("invincible", 5)
		player_state_collection[player_id].instance = new_instance
		instance.RemovePlayer(player_id)
		new_instance.SpawnPlayer(player_container)
		
		if new_instance.arena:
			spawnpoint = Vector2.ZERO
			
			rpc_id(player_id, "Arena", {
				"name": new_instance.arena_type.capitalize() + " Arena",
				"id": instance_id,
				"position": spawnpoint
			})
		elif not "island" in instance_id:
			spawnpoint = new_instance.GetMapSpawnpoint()
			
			rpc_id(player_id, "Dungeon", {
				"map": new_instance.map,
				"name": instance.object_list[instance_id]["name"],
				"id": instance_id,
				"room_size": new_instance.room_size,
				"position": spawnpoint
			})
		else:
			spawnpoint = new_instance.GetMapSpawnpoint()
			
			rpc_id(player_id, "Island", {
				"name": new_instance.ruler,
				"id":instance_id,
				"position": spawnpoint
			}, new_instance.which if "special" in new_instance.name else null)
		
		player_state_collection[player_id] = {
			"time": OS.get_system_time_msecs(),
			"position": spawnpoint,
			"animation": {
				"animation" : "Idle",
				"direction" : Vector2.ZERO
			},
			"instance": new_instance
		}
		CharacterData(player_id, player_container.character)

remote func FetchChunk(chunk):
	var player_id = get_tree().get_rpc_sender_id()
	var instance = player_state_collection[player_id].instance
	
	if instance.has_method("GetIslandChunk"):
		rpc_id(player_id, "ReturnChunk", instance.GetIslandChunk(chunk), chunk)

#COMMANDS
remote func RecieveMessage(message):
	var player_id = get_tree().get_rpc_sender_id()
	if not VerifyPlayer(player_id): return
	
	Chat.RecieveMessage(message, player_id)

func Message(player_id, type, message):
	if type == "system": rpc_id(player_id, "RecieveMessage", message, "System")
	elif type == "warning": rpc_id(player_id, "RecieveMessage", message, "SystemWARN")
	elif type == "error": rpc_id(player_id, "RecieveMessage", message, "SystemERROR")
	elif type == "success": rpc_id(player_id, "RecieveMessage", message, "SystemSUCCESS")

func Speech(enemy_name, enemy_id, message, instance_id):
	rpc("RecieveMessage", message, "Enemy", enemy_name, enemy_id, instance_id)

func FindPlayerByName(username):
	for _username in player_id_by_name.keys():
		if _username.to_lower() == username.to_lower():
			return player_id_by_name[_username]
	return null
	

#PLAYER INTERACTION

func SendError(player_id, error):
	rpc_id(player_id, "RecieveError", error)

func IdentifierToString(identifier):
	var words = identifier.split("_")
	var proper_string = ""
	for word in words:
		proper_string += word.capitalize() + " "
	proper_string = proper_string.strip_edges()
	
	return proper_string

func NotifyDeath(player_id, enemy_name, character_lvl, character_class):
	rpc_id(player_id, "Death")
	yield(get_tree().create_timer(0.1), "timeout")
	network.disconnect_peer(player_id)
	_Peer_Disconnected(player_id)
	rpc("RecieveMessage","Lv. " + str(character_lvl) + " " + str(character_class) + " " + str(player_name_by_id[player_id]) + " has been killed by a "+IdentifierToString(enemy_name), "System")

func SetHealth(player_id, max_health, health):
	if player_id in get_tree().get_network_connected_peers():
		rpc_id(player_id,"SetHealth",max_health, health)

#Utility functions

func generate_unique_id():
	var timestamp = OS.get_unix_time()
	var random_value = randi()
	return (str(timestamp) + "_" + str(random_value)).sha256_text()
