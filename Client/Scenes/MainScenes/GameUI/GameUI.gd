extends CanvasLayer

onready var container = get_node("Container")
onready var active_node = container.get_child(0)

var game_node = preload("res://Scenes/MainScenes/GameUI/Components/Game/Game.tscn")
var inventory_node = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Inventory.tscn")
var stats_node = preload("res://Scenes/MainScenes/GameUI/Components/Stats/Stats.tscn")
var nearby_node = preload("res://Scenes/MainScenes/GameUI/Components/Nearby/Nearby.tscn")
var trade_request_node = preload("res://Scenes/MainScenes/GameUI/Components/Trade/Components/TradeRequest.tscn")
var trade_node = preload("res://Scenes/MainScenes/GameUI/Components/Trade/Trade.tscn")
var dialogue_node = preload("res://Scenes/MainScenes/GameUI/Components/Dialogue/Dialogue.tscn")
var build_node = preload("res://Scenes/MainScenes/GameUI/Components/Building/Building.tscn")
var classes_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Classes.tscn")
var achievements_node = preload("res://Scenes/MainScenes/GameUI/Components/Achievements/Achievements.tscn")
var settings_node = preload("res://Scenes/MainScenes/GameUI/Components/Settings/Settings.tscn")

var attack_joystick = Vector2.ZERO
var move_joystick = Vector2.ZERO
var focused = false
var unread_messages = []
var loot = {}
var portals = {}

func Popup(node):
	var active_name = active_node.name
	
	active_node.queue_free()
	active_node = node
	container.add_child(active_node)
	
	attack_joystick = Vector2.ZERO
	move_joystick = Vector2.ZERO
	
	if "Build" in active_name and GameHandler.tutorial == 14:
		active_node.ClosedBuild()

func Account(data):
	if AccountHandler.data.achievements.hash() != data.achievements.hash():
		for achievement in data.achievements.keys():
			if not achievement in AccountHandler.data.achievements:
				Animations.animation_buffer.append({
					"type" : achievement,
					"which" : "History Of Beasts"
				})

func Character(data):
	var bars_node = active_node.get_node("HBoxContainer/Bars")
	var inventory_node = get_node_or_null("Container/Inventory")
	var stats_node = get_node_or_null("Container/Stats")
	
	if GameHandler.character and data.class != GameHandler.character.class:
		Animations.animation_buffer.append({
			"type" : "DiscoverClass",
			"which" : data.class
		})
	
	if bars_node:
		bars_node.SetExp(200 * data.level if (data.level < 10) else 2500, data.exp, data.level)
	
	if inventory_node:
		inventory_node.SetInventory(data.inventory)
		inventory_node.SetGear(data.gear)
	elif stats_node:
		stats_node.Character(data)

func ConfirmUsername(result):
	if "Name" in active_node.name:
		active_node.Return(result)

func DeadEnemy(enemy_type):
	if enemy_type == "tutorial_crab" and GameHandler.tutorial == 5:
		if not active_node.has_method("KilledCrab"):
			Popup(game_node.instance())
		active_node.KilledCrab()
	elif enemy_type == "tutorial_nature_druid" and GameHandler.tutorial == 9:
		if not active_node.has_method("KilledDruid"):
			Popup(game_node.instance())
		active_node.KilledDruid()
	elif enemy_type == "tutorial_troll_king" and GameHandler.tutorial == 11:
		if not active_node.has_method("KilledBoss"):
			Popup(game_node.instance())
		active_node.DefeatedBoss()

func QuestData(quest):
	var game_node = get_node_or_null("Container/Game")
	
	if game_node and game_node.get_node_or_null("Quest"):
		game_node.get_node("Quest").Quest(quest)

func OverLoot():
	if GameHandler.tutorial == 6 and active_node.has_method("OverLoot"):
		active_node.OverLoot()

var got_items = []
func GotItem(item):
	if GameHandler.tutorial == 7 and item == 400:
		Popup(game_node.instance())
		active_node.GotHelmet()
	if GameHandler.tutorial == 12 and item == -2:
		got_items.append("stone")
		if "bow" in got_items:
			Popup(game_node.instance())
			active_node.CollectedLoot()
	if GameHandler.tutorial == 12 and item == 166:
		got_items.append("bow")
		if "stone" in got_items:
			Popup(game_node.instance())
			active_node.CollectedLoot()

func UseItem(item):
	if GameHandler.tutorial == 7 and item == 400:
		GameHandler.tutorial += 1
		Popup(game_node.instance())
		active_node.EquipHelmet()
	if GameHandler.tutorial == 8 and item == 400:
		Popup(game_node.instance())
		active_node.EquipHelmet()
	if GameHandler.tutorial == 12 and item == 166:
		got_items.append("bow")
		if "stone" in got_items:
			Popup(game_node.instance())
			active_node.CollectedLoot()
	if GameHandler.tutorial == 15 and item == -2:
		Popup(game_node.instance())
		active_node.UsedStone()

func Ascended():
	if GameHandler.tutorial == 16:
		Popup(game_node.instance())
		active_node.Ascended()

func _physics_process(delta):
	var player = GameHandler.player_node
	var buttons_node = active_node.get_node_or_null("GUIButtons")
	var mobile_buttons = active_node.get_node_or_null("MobileButtons")
	var result
	var portal_name
	var portal_id
	
	if is_instance_valid(player) and len(loot) > 0:
		var loot_id
		var loot_distance = 999
		var loot_tier = -1
		
		for id in loot.keys():
			var tier = loot[id][0]
			var position = loot[id][1]
			var distance = position.distance_to(player.position)
			
			if distance < 8 and tier > loot_tier or (distance < loot_distance and tier == loot_tier):
				loot_distance = distance
				loot_tier = tier
				loot_id = id
		
		result = loot_id
	
	if player and len(portals) > 0:
		var portal_distance = 999
		
		for id in portals.keys():
			var position = portals[id].position
			var distance = position.distance_to(player.position)
			
			if distance < portal_distance:
				portal_id = id
				portal_distance = distance
				portal_name = portals[id].name
	
	if buttons_node:
		buttons_node.Loot(result)
	if mobile_buttons:
		mobile_buttons.Portal(portal_id, portal_name)
	if result: OverLoot()
	UpdateLoot(result)

func UpdateLoot(id):
	if "Inventory" in active_node.name:
		if not id and not active_node.loot_id: return
		
		active_node.UpdateLoot(id)

func Loot(id, items, position):
	var max_tier = 0
	var loot_bag_tiers = {
		0 : 0,
		1 : 0,
		2 : 1,
		3 : 1,
		4 : 2,
		5 : 2,
		6 : 3,
	}
	
	var i = 0
	for raw_item in items:
		if raw_item == null: continue
		
		var tier = ClientData.GetItem(raw_item.item).tier
		max_tier = max(max_tier, int(tier))
		if tier == "UT": max_tier = 6
	
	var bag_tier = loot_bag_tiers[max_tier]
	loot[id] = [bag_tier, position]

func OffLoot(loot_id):
	loot.erase(loot_id)

func HandleMessage(message, username, classname):
	var chat_node = active_node.get_node_or_null("Chat")
	
	if chat_node: chat_node.Message(message, username, classname)
	
	elif "System" in username and GameHandler.tutorial < 0:
		Popup(game_node.instance())
		chat_node = active_node.get_node_or_null("Chat")
		if chat_node:
			chat_node.Message(message, username, classname)

func Portal(dungeon_id, dungeon_name, pos):
	portals[dungeon_id] = {
		"name" : dungeon_name,
		"position" : pos
	}

func OffPortal(dungeon_id, dungeon_name):
	portals.erase(dungeon_id)

func UpdateTrade(data):
	if "Trade" in active_node.name: active_node.Set(data)
	else:
		var trade_instance = trade_node.instance()
		Popup(trade_instance)
		trade_instance.Set(data)

func HouseData(data):
	AccountHandler.data.home = data
	
	if 'Building' in active_node.name:
		active_node.SetBuildings(data)
