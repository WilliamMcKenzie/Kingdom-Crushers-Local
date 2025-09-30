extends Node2D

onready var server = get_node("/root/Server")

var instance
var is_dead
var email

var last_updated = OS.get_system_time_secs()
var character_index
var current_quest
var account_data
var character
var gear = {}
var stats = {}

var max_health = 100
var health = 100
var stat_buffs = {
	"health" : {"add" : 0, "timer" : 0},
	"attack" : {"add" : 0, "timer" : 0},
	"defense" : {"add" : 0, "timer" : 0},
	"speed" : {"add" : 0, "timer" : 0},
	"dexterity" : {"add" : 0, "timer" : 0},
	"vitality" : {"add" : 0, "timer" : 0},
}
var status_effects = {
	"damaging" : 0,
	"berserk" : 0,
	"armored" : 0,
	"healing" : 0,
	"invincible" : 0,
}

var last_teleported = 0
var running_time = 0
var last_tick = 0
var heal_rate = 1

var last_position
var loaded_chunks = {}
var player_state = {
	"time" : OS.get_system_time_msecs(),
	"position" :Vector2.ZERO,
	"animation" : {
		"animation" : "Idle",
		"direction" : Vector2.ZERO
	}, 
	"sprite" : {
		"rect" : Rect2(Vector2(0,0),Vector2(80,40)),
		"class" : "Apprentice",
		"gear" : {},
		"level" : 0
	}
}

var time_between_shots = INF
var last_shot_time = 0
var timer = 0

func AccountData(data):
	character = data.characters[character_index]
	
	account_data = data
	gear = character.gear.duplicate()
	stats = character.stats.duplicate()
	for stat in stats.keys():
		stats[stat] = CompileGear(stat)
	
	health = stats.health
	server.CharacterData(int(name), character)
	
	if GetHouse():
		GetHouse().AccountData(account_data)

func _physics_process(delta):
	if not account_data or "target" in self: return
	if not character: return
	
	character.ability_cooldown -= delta
	running_time += delta
	timer += 1
	HandleAfk()
	
	ManageHealing()
	if timer >= 60 * 10:
		timer = 0
		GetHouse().SaveData()
		account_data.last_online = OS.get_datetime()
		HubConnection.UpdateAccountData(email, account_data)
	if timer % 60 == 0:
		StatBuffs()
		Effects()
		Statistics()
		Quest()
#	if character.class == "Noble":
#		heal_rate = heal_rate / max_health * 200.0

func HandleAfk():
	if OS.get_system_time_secs() - last_updated > 10:
		if not int(name) in server.get_tree().get_network_connected_peers():
			server._Peer_Disconnected(int(name))
		else:
			server.network.disconnect_peer(int(name))

func Quest():
	var island = "island" in instance.name
	var dungeon = "dungeon" in instance.name
	
	if island:
		IslandQuest()
	elif dungeon:
		DungeonQuest()
	else:
		current_quest = null
	
	server.QuestData(int(name), current_quest)

func IslandQuest():
	var closest = OS.get_system_time_msecs()
	var nearby_enemies = {}
	var quest_enemies = []
	var tile
	
	if character.level < 2:
		quest_enemies = instance.beach_enemies
		tile = 2
	elif character.level < 4:
		quest_enemies = instance.forest_enemies
		tile = 3
	elif character.level < 7:
		quest_enemies = instance.plains_enemies
		tile = 4
	elif character.level < 10:
		quest_enemies = instance.badlands_enemies
		tile = 5
	
	if character.level >= 10:
		var valid_ruler = (
			instance.ruler
			and "ruler_id" in instance
			and instance.ruler_id
			and instance.enemy_list.has(instance.ruler_id)
		)
		
		if valid_ruler:
			current_quest = {
				"name": instance.ruler,
				"position": instance.enemy_list[instance.ruler_id].position,
				"id" : instance.ruler_id
			}
		else:
			current_quest = null
	else:
		for id in instance.enemy_list.keys():
			var enemy = instance.enemy_list[id]
			var valid = (
				enemy.name in quest_enemies
				and enemy.position.distance_to(position) < closest
			)
			
			if valid:
				closest = enemy.position.distance_to(position)
				current_quest = {
					"name": enemy.name,
					"position": enemy.position,
					"id" : id
				}
		
		if current_quest and current_quest.id in instance.enemy_list:
			var enemy = instance.enemy_list[current_quest.id]
			current_quest = {
				"name": enemy.name,
				"position": enemy.position,
				"id" : current_quest.id
			} 
		elif tile and len(quest_enemies) and tile in instance.tile_points:
			var tile_list = instance.tile_points[tile]
			current_quest = {
				"name": quest_enemies[0],
				"position": tile_list[0],
				"id" : null
			}

func DungeonQuest():
	var closest = 99999
	
	for id in instance.enemy_list.keys():
		var enemy = instance.enemy_list[id]
		var valid = (
			enemy.name == instance.dungeon_boss
			and enemy.position.distance_to(position) < closest
		)
		
		if valid:
			closest = enemy.position.distance_to(position)
			current_quest = {
				"name": enemy.name,
				"position": enemy.position,
				"id" : id
			}
	
	if current_quest and not current_quest.id in instance.enemy_list:
		current_quest = null

func StatBuffs():
	for stat in stat_buffs.keys():
		stat_buffs[stat].timer -= 1
		
		if stat_buffs[stat].timer <= 0:
			character.stat_buffs.erase(stat)
			stats[stat] -= stat_buffs[stat].add
			server.CharacterData(int(name), character)
			stat_buffs.erase(stat)

func Effects():
	for effect in status_effects.keys():
		status_effects[effect] -= 1
		
		if status_effects[effect] <= 0 and name in instance.player_list:
			instance.player_list[name].status_effects.erase(effect)
			character.status_effects.erase(effect)
			server.CharacterData(int(name), character)
			status_effects.erase(effect)

func Statistics():
	if not "tiles_covered" in account_data.statistics:
		account_data.statistics.tiles_covered = 0
	if not "tiles_covered" in character.statistics:
		character.statistics.tiles_covered = 0
	if last_position:
		UpdateStatistics("tiles_covered", round(last_position.distance_to(position) / 8.0))
	last_position = position
	
	for achievement in account_data.achievements:
		if not account_data.achievements[achievement] and ServerData.GetAchievement(achievement):
			var data = ServerData.GetAchievement(achievement)
			if data.which == "classes_unlocked":
				var unlocked = true
				for _class in data.classes:
					if not account_data.classes.has(_class) or not account_data.classes[_class]:
						unlocked = false
				
				if unlocked:
					GetAchievement(achievement)
	
	server.AccountData(int(name), account_data)

var updated_achievements = false
func UpdateStatistics(which, amount_increase):
	if not updated_achievements:
		for category in ServerData.achievement_catagories:
			for achievement in ServerData.achievement_catagories[category].achievements:
				if not account_data.achievements.has(achievement):
					account_data.achievements[achievement] = false
	
	#Handle character statistics
	if not character.statistics.has(which):
		character.statistics[which] = 0
	character.statistics[which] += amount_increase
	
	#Handle global statistics
	if not account_data.statistics.has(which):
		account_data.statistics[which] = 0
	account_data.statistics[which] += amount_increase
	
	#Class quests
	for _achievement in ServerData.GetCharacter(character.class).quests:
		var achievement = ServerData.GetAchievement(_achievement)
		
		#In case account is outdated
		if not character.statistics.has(which):
			character.statistics[which] = 0
		
		#If standard achievement, simply check the amount
		if achievement.which == which and character.statistics[which] >= achievement.amount and not achievement.has("enemies"):
			GetAchievement(_achievement)
		#In case of enemies killed, check the enemies in statistics
		elif achievement.which == "enemies_killed" and achievement.has("enemies") and achievement.enemies.has(which):
			var total = 0
			for enemy in achievement.enemies:
				if character.statistics.has(enemy):
					total += character.statistics[enemy]
			if total >= achievement.amount:
				GetAchievement(_achievement)
	
	#Regular achievements
	for _achievement in account_data.achievements:
		if account_data.achievements[_achievement] == true or not ServerData.GetAchievement(_achievement):
			continue
		var achievement = ServerData.GetAchievement(_achievement)
		
		#In case account is outdated
		if not account_data.statistics.has(which):
			account_data.statistics[which] = 0
		
		#If standard achievement, simply check the amount
		if achievement.which == which and account_data.statistics[which] >= achievement.amount and not achievement.has("enemies"):
			account_data.achievements[_achievement] = true
			GetAchievement(_achievement)
		
		#In case of enemies killed, check the enemies in statistics
		elif achievement.which == "enemies_killed" and achievement.has("enemies") and achievement.enemies.has(which):
			var total = 0
			for enemy in achievement.enemies:
				if account_data.statistics.has(enemy):
					total += account_data.statistics[enemy]
			if total >= achievement.amount:
				GetAchievement(_achievement)

func GetAchievement(achievement_name):
	var character_data = ServerData.GetCharacter(character.class)
	var achievement_data = ServerData.GetAchievement(achievement_name)
	
	account_data.gold += achievement_data.gold
	account_data.achievements[achievement_name] = true
	if achievement_data.gold > 0:
		server.Message(int(name), "success", "You recieved " + str(achievement_data.gold) + " gold!")
	
	#Check if unlocked new furntiure
	for building_id in ServerData.buildings.keys():
		var building = ServerData.GetBuilding(building_id)
		
		if "achievement" in building and building.achievement == achievement_name:
			account_data.home.inventory[building.type+"s"][building_id] += 1
	
	#Check if unlocked new char
	if character_data.quests.has(achievement_name):
		character.class = character_data.quests[achievement_name]
		account_data.classes[character_data.quests[achievement_name]] = true
		
		var class_bonus_stats = character_data.bonus_stats
		for stat in character.stats.keys():
			character.stats[stat] += class_bonus_stats[stat]
		
		stats = character.stats.duplicate()
		for stat in stats.keys():
			stats[stat] = CompileGear(stat)
	
	server.AccountData(int(name), account_data)
	server.CharacterData(int(name), character)

func ManageHealing():
	var max_health = stats.health
	
	#heal_rate = 4.0 / (stats.vitality * 6 * (max_health / 500.0))
	heal_rate = 4.0 / (stats.vitality * 2)
	
	if "healing" in status_effects:
		#heal_rate = 4.0 / (stats.vitality * 10 * (max_health / 500.0))
		heal_rate = 4.0 / (stats.vitality * 5)
	
	for i in range(floor((running_time - last_tick) / heal_rate)):
		last_tick = running_time
		if health < max_health:
			health += 1
			server.SetHealth(int(name), max_health, health)
	
	health = min(health, max_health)

func GiveItem(item_id, delay = 0):
	yield(get_tree().create_timer(delay), "timeout")
	
	var server = server
	instance.SpawnLootBag([
		{
			"item" : item_id,
			"id" : server.generate_unique_id()
		}],
		int(name),
		self.position)

#TRADE
var other_name
var other_accepted
var other_selection
var other_container
var other_inventory
var accepted
var selection

func StartTrade(username, container):
	ResetTrade()
	
	other_container = container
	other_inventory = container.character.inventory.duplicate()
	other_name = username
	var data = {
		"inventory" : other_inventory,
		"selection" : other_selection,
		"accepted" : other_accepted,
		"name" : other_name
	}
	server.UpdateTrade(int(name), data)

func ResetTrade():
	other_accepted = false
	other_inventory = []
	other_selection = [false, false, false, false, false, false, false, false]
	selection = [false, false, false, false, false, false, false, false]

func AcceptOffer():
	if other_inventory.hash() != other_container.character.inventory.hash():
		server.EndTrade(int(other_container.name), int(name))
	
	if not is_instance_valid(other_container):
		server.EndTrade(int(name), int(name))
	
	if other_accepted: return FinishTrade()
	
	var free_slots = 0
	var selection_count = 0
	var other_free_slots = 0
	var other_selection_count = 0
	
	for item in character.inventory: if not item: free_slots += 1
	for item in selection: if not item:
		selection_count += 1
		free_slots += 1
	for item in other_inventory: if not item: other_free_slots += 1
	for item in selection: if not item:
		other_selection_count += 1
		other_free_slots += 1
	
	var overflow = (
		free_slots < other_selection_count
		or other_free_slots < selection_count
	)
	
	if not overflow:
		other_container.Accepted()

func Accepted():
	other_accepted = true
	var data = {
		"inventory" : other_inventory,
		"selection" : other_selection,
		"accepted" : other_accepted,
		"name" : other_name
	}
	
	server.UpdateTrade(int(name), data)

func Offer(offer):
	selection = offer
	other_container.other_selection = selection
	other_container.other_accepted = false
	other_accepted = false
	
	var data = {
		"inventory" : character.inventory,
		"selection" : selection,
		"accepted" : false,
		"name" : account_data.username
	}
	server.UpdateTrade(int(other_container.name), data)
	
	data = {
		"inventory" : other_inventory,
		"selection" : other_selection,
		"accepted" : false,
		"name" : other_name
	}
	server.UpdateTrade(int(name), data)

func CancelOffer():
	ResetTrade()
	if is_instance_valid(other_container):
		server.EndTrade(int(name), int(other_container.name))
	else:
		server.EndTrade(int(name), int(name))

func FinishTrade():
	var other_new_items = []
	var new_items = []
	
	print(character.inventory)
	
	
	for i in range(8):
		if selection[i] and not character.inventory[i]:
			print(i)
			print(character.inventory)
			return
		if other_selection[i] and not other_inventory[i]: return
		
		if selection[i]:
			other_new_items.append(character.inventory[i].duplicate())
			character.inventory[i] = null
		if other_selection[i]:
			new_items.append(other_inventory[i].duplicate())
			other_inventory[i] = null
	
	for i in range(character.inventory.size()):
		if not character.inventory[i] and len(new_items) > 0:
			character.inventory[i] = new_items[0].duplicate()
			new_items.pop_front()
		if not other_inventory[i] and len(other_new_items) > 0:
			other_inventory[i] = other_new_items[0].duplicate()
			other_new_items.pop_front()
	
	other_container.character.inventory = other_inventory
	server.CharacterData(int(name), character)
	server.CharacterData(int(other_container.name), other_container.character)
	server.DoneTrade(int(other_container.name), int(name))

func UseHelmet():
	if character.ability_cooldown > 0.5 or not gear.helmet: return
	
	var helmet = ServerData.GetItem(gear.helmet.item)
	var player_list = instance.player_list
	var player_position = self.position
	var buffs = helmet.buffs
	
	character.ability_cooldown = helmet.cooldown
	UpdateStatistics("ability_used", 1)
	
	for buff in buffs.keys():
		var buff_range = buffs[buff].range
		
		if buff_range == 0:
			GiveEffect(buff, buffs[buff].duration)
			continue
		
		for player_id in player_list.keys():
			if player_list[player_id].position.distance_to(player_position) <= buff_range*5:
				var player_container = instance.GetPlayer(player_id)
				
				if is_instance_valid(player_container):
					player_container.GiveEffect(buff, buffs[buff].duration)
				else:
					instance.RemovePlayer(player_id)

func GiveEffect(effect, duration):
	var valid = (
		character
		and status_effects[effect] > duration if effect in status_effects else true
	)
	if not valid: return
	
	status_effects[effect] = duration
	if not character.status_effects.has(effect):
		character.status_effects.append(effect)
	if not instance.player_list[name].has(effect):
		instance.player_list[name].status_effects.append(effect)
	
	server.CharacterData(int(name), character)

func GiveBuff(amount, stat, duration):
	if stat_buffs.has(stat):
		stats[stat] -= stat_buffs[stat].add
	
	stat_buffs[stat] = {"add" : amount, "timer" : duration}
	character.stat_buffs[stat] = amount
	stats[stat] += stat_buffs[stat].add
	server.CharacterData(int(name), character)

#Items

func IncreaseStat(stat):
	if character.ascension_stones > character.used_ascension_stones:
		character.used_ascension_stones += 1
		if stat == "health":
			character.stats[stat] += 5
			health += 5
		elif stat in character.stats:
			character.stats[stat] += 1
		
		stats = character.stats.duplicate()
		for stat in stats.keys():
			stats[stat] = CompileGear(stat)
		
		server.CharacterData(int(name), character)

func Max(limitless = false):
	character.ascension_stones += ServerData.GetCharacter(character.class).ascension_stones - character.ascension_stones
	if limitless:
		character.ascension_stones += 999
	
	server.CharacterData(int(name), character)
	server.Message(int(name), "success", "You feel your strength grow...")

func UseItem(index, from_npc = false):
	var selected_item_raw = character.inventory[index]
	if selected_item_raw == null: return
	
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	if selected_item.type != "Consumable" and selected_item.name != "Blue Tuna": return
	
	if "gift" in selected_item.use:
		var gifts = {
			"halloween" : {
				9 : 4, 
				10 : 4, 
				11 : 4,
				12 : 4,
				406 : 1,
			}
		}
		var gift_pool = gifts[selected_item.use.split(" ")[1]]
		var gift_arr = []
		for gift_id in gift_pool.keys():
			for i in range(gift_pool[gift_id]):
				gift_arr.append(gift_id)
		character.inventory[index] = {
			"item" : gift_arr[randi() % len(gift_arr)],
			"id" : server.generate_unique_id()
		}
	elif "buff" in selected_item.use:
		var data = selected_item.use.split(" ")
		var which = data[1]
		var amount = int(data[2])
		var duration = int(data[3])
		GiveBuff(amount, which, duration)
		character.inventory[index] = null
	elif "ascend" in selected_item.use and character.ascension_stones < ServerData.GetCharacter(character.class).ascension_stones:
		character.ascension_stones += int(selected_item.use.split(" ")[1])
		character.inventory[index] = null
		server.Message(int(name), "success", "You feel your strength grow...")
	elif "ascend" in selected_item.use:
		server.Message(int(name), "warning", "Class is fully ascended, evolve to ascend further")
	elif "open" in selected_item.use:
		if from_npc and selected_item.use == "open tundra":
			character.inventory[index] = null
			server.nexus.OpenPortal("special_island", server.nexus.GetBoatSpawnpoints(), Vector2(802,802), "oracle", "tundra")
	
	server.CharacterData(int(name), character)

func EquipItem(index):
	var item = character.inventory[index]
	if item == null: return
	
	var data = ServerData.GetItem(item.item)
	var slot = data.slot if "slot" in data else null
	if not slot or slot == "na": return
	
	var replaced_item = character.gear[slot]
	
	character.inventory[index] = replaced_item
	character.gear[slot] = item
	gear[slot] = item
	
	stats = character.stats.duplicate()
	for stat in stats.keys():
		stats[stat] = CompileGear(stat)
	
	server.SetHealth(int(name), stats.health, health)
	server.CharacterData(int(name), character)

func ChangeItem(to_data, from_data):
	var selected_item_raw = character[from_data.parent][from_data.index]
	var replaced_item_raw = character[to_data.parent][to_data.index]
	
	#Item you are dragging
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	
	#When you are trying to place a item in the wrong gear slot
	if to_data.parent == "gear":
		if to_data.index != selected_item.slot: return
		else: gear[to_data.index] = selected_item_raw
	
	#Vice versa, trying to place gear slot into inventory
	if from_data.parent == "gear":
		if replaced_item_raw != null:
			var replaced_item = ServerData.GetItem(replaced_item_raw.item)
			
			if replaced_item.slot == from_data.index:
				gear[from_data.index] = replaced_item_raw
		else:
			gear.erase(from_data.index)
	
	character[from_data.parent][from_data.index] = replaced_item_raw
	character[to_data.parent][to_data.index] = selected_item_raw
	stats = character.stats.duplicate()
	for stat in stats.keys():
		stats[stat] = CompileGear(stat)
	
	server.CharacterData(int(name), character)

func DropItem(data):
	if "loot" in data.parent:
		return
	var selected_item_raw = character[data.parent][data.index]
	var Server = server
	
	instance.SpawnLootBag([selected_item_raw], null, server.player_state_collection[int(name)].position)
	
	if data.parent == "gear":
		gear.erase(data.index)
		stats = character.stats.duplicate()
		for stat in stats.keys():
			stats[stat] = CompileGear(stat)
	
	character[data.parent][data.index] = null
	
	server.CharacterData(int(name), character)

func LootItem(to_data, from_data):
	
	#Getting loot bag contents
	var loot_id
	if to_data.parent.split(" ")[0] == "loot":
		loot_id = to_data.parent
	else:
		loot_id = from_data.parent
	
	#Check if it is soulbound, if so make sure the right player is requesting
	if not get_parent().get_parent().get_parent().object_list.has(loot_id):
		return
	if get_parent().get_parent().get_parent().object_list[loot_id].soulbound == true and str(get_parent().get_parent().get_parent().object_list[loot_id].player_id) != name:
		return
	
	var object_reference = get_parent().get_parent().get_parent().object_list[loot_id]
	var loot = object_reference.loot
	if not object_reference.has("permanent"):
		object_reference.end_time = OS.get_system_time_msecs()+40000
	
	#Identifying items
	var selected_item_raw
	var replaced_item_raw
	
	#Set dragging item
	if from_data.parent.split(" ")[0] == "loot":
		selected_item_raw = loot[from_data.index]
	else:
		selected_item_raw = character[from_data.parent][from_data.index]
	#Set item to replace
	if to_data.parent.split(" ")[0] == "loot":
		replaced_item_raw = loot[to_data.index]
	else:
		replaced_item_raw = character[to_data.parent][to_data.index]
	
	#Item you are dragging
	if not selected_item_raw:
		return
	var selected_item = ServerData.GetItem(selected_item_raw.item)
	
	#Different Scenarios
	
	#Taking loot into inventory
	if to_data.parent == "inventory":
		loot[from_data.index] = replaced_item_raw
		character[to_data.parent][to_data.index] = selected_item_raw
	
	#From gear to loot
	if from_data.parent == "gear":
		if replaced_item_raw != null:
			var replaced_item = ServerData.GetItem(replaced_item_raw.item)
			
			if replaced_item.slot != selected_item.slot:
				return
			gear[from_data.index] = replaced_item_raw
		else:
			gear.erase(from_data.index)
		
		loot[to_data.index] = selected_item_raw
		character[from_data.parent][from_data.index] = replaced_item_raw
	
	#From loot to gear
	if to_data.parent == "gear":
		if to_data.index != selected_item.slot:
			return
		else:
			gear[to_data.index] = selected_item_raw
		
		loot[from_data.index] = replaced_item_raw
		character[to_data.parent][to_data.index] = selected_item_raw
	
	#Putting inventory item into loot bag
	if from_data.parent == "inventory":
		loot[to_data.index] = selected_item_raw
		character[from_data.parent][from_data.index] = replaced_item_raw

	#Moving around items inside loot bag
	if to_data.parent.split(" ")[0] == "loot" and from_data.parent.split(" ")[0] == "loot":
		loot[to_data.index] = selected_item_raw
		loot[from_data.index] = replaced_item_raw
		
	if loot == [null,null,null,null,null,null,null,null] and not object_reference.has("permanent"):
		get_parent().get_parent().get_parent().object_list.erase(loot_id)
	
	stats = character.stats.duplicate()
	for stat in stats.keys():
		stats[stat] = CompileGear(stat)
	
	server.CharacterData(int(name), character)

func AddExp(exp_amount, enemy_name, enemy_id):
	if ServerData.enemies_tracked.has(enemy_name):
		UpdateStatistics(enemy_name, 1)
	UpdateStatistics("enemies_killed", 1)
	
	var exp_pool = exp_amount
	if current_quest and str(enemy_id) == str(current_quest.id):
		exp_pool = exp_amount * 3
	
	while exp_pool > 0:
		var level_exp = 200 * character.level if (character.level < 10) else 2500
		var exp_to_level = level_exp - character.exp
		
		if exp_pool < exp_to_level:
			character.exp += floor(exp_pool)
			exp_pool = 0
		else:
			exp_pool -= exp_to_level
			character.exp = 0
			character.level += 1
			if character.level < 10:
				health = stats.health
				var stat_rolls = {
					"health" : 40,
					"attack" : 2,
					"defense" : 0,
					"speed" : 1,
					"dexterity" : 2,
					"vitality" : 2,
				}
				for stat in character.stats:
					character.stats[stat] += stat_rolls[stat]
	
	stats = character.stats.duplicate()
	for stat in stats.keys():
		stats[stat] = CompileGear(stat)
	server.SetHealth(int(name), stats.health, health)
	server.CharacterData(int(name), character)
	server.rpc_id(int(name), "RemoveEnemy", enemy_id)

func DealDamage(damage, enemy_name):
	if not character: return
	
	var practical_defense = stats.defense
	practical_defense *= 1.5 if "armored" in status_effects else 1
	
	var total_damage = ceil(damage / (1 + (practical_defense / 100.0)))
	total_damage = 0 if "invincible" in status_effects else total_damage
	
	health -= total_damage
	
	UpdateStatistics("damage_taken", total_damage)
	
	server.SetHealth(int(name), stats.health, health)
	
	if health < 1 and "tutorial" in instance.name:
		health = 50
	elif health < 1 and not is_dead:
		if instance.arena:
			health = stats.health
			account_data.time_tracker[instance.arena_type] = OS.get_datetime()
			server.SetHealth(int(name), stats.health, health)
			server.AccountData(int(name), account_data)
			server.CharacterData(int(name), character)
			server.ForcedPort(int(name),  server.nexus.object_list.arena_master.position - Vector2(24,0))
			server.rpc_id(int(name), "Wave", -1, 0)
			server.rpc_id(int(name), "Dialogue", {
				"text" : ["Not bad...", "You impress me warrior.", "Come fight again some time!"],
				"character_rect" : Vector2(20,0),
			})
		else:
			Death(enemy_name)

func Death(enemy_name):
	UpdateStatistics("deaths", 1)
	var username = server.player_name_by_id[int(name)]
	server.NotifyDeath(int(name), enemy_name, character.level, character.class)
	account_data.characters.remove(character_index)
	
	if not character.has("revive_cost"):
		character.revive_cost = DetermineReviveCost(character.level)
		account_data.graveyard.append(character)
	else:
		character.revive_cost = 9999999
		character.permadead = true
		account_data.graveyard.append(character)
	if account_data.graveyard.size() > 10:
		account_data.graveyard.pop_front()
	
	if not "admin" in account_data and not "target" in self:
		HubConnection.UpdateLeaderboard(username, character)
	is_dead = true

func DetermineReviveCost(reputation):
	var cost = reputation * 10
	if reputation > 20000:
		cost = 5000
	elif reputation > 10000:
		cost = 4000
	elif reputation > 5000:
		cost = 3000
	elif reputation > 1000:
		cost = 2000
	elif reputation > 500:
		cost = 1000
	elif reputation > 100:
		cost = 500
	elif reputation > 20:
		cost = 200
	return cost

func GetHouse():
	return server.nexus.get_node_or_null("house " + name)

func GiveGold(amount):
	account_data.gold += amount
	server.AccountData(int(name), account_data)

func CompileGear(stat):
	var total = stats[stat]
	
	for item in gear.values(): if item:
		var data = ServerData.GetItem(item.item, true, character.class)
		if stat in data.stats:
			total += data.stats[stat]
	
	return total
