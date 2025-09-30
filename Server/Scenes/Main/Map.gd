extends Node2D

var collision_layer = 1
var arena = false
var portal_name

var player_list = {}
var enemy_list = {}
var object_list = {}
var projectile_list = {}

var projectile_id_counter = 0

var tick_rate = 0.1
var running_time = 0
var last_tick = 0
var use_chunks = false
var expression = Expression.new()
var reference = self

onready var server = get_node("/root/Server")
onready var players_node = get_node("YSort/Players")
onready var objects_node = get_node("YSort/Objects")
var cached_expressions = {}

func _ready():
	server.player_instance_tracker[self] = []

func ProjectileInteraction(projectile, projectile_position):
	var chunk_players
	if reference.has_method("CalculateChunk"):
		var chunk = reference.CalculateChunk(projectile["position"])
		var chunk_exists = chunk in reference.chunks
		chunk_players = reference.chunks[chunk].players if chunk_exists else null
	
	var space_state = get_world_2d().direct_space_state
	var collision = space_state.intersect_point(projectile_position + global_position, 1, [], 1, true, true)
	var valid_collision = collision.size() > 0
	
	var players = player_list if not chunk_players else chunk_players
	for player_id in players.keys():
		var player_position = players[player_id].position + Vector2(0,-4)
		var within_range = player_position.distance_to(projectile_position) <= projectile.size
		var doublehit_check = not player_id in projectile.hit_players
		
		if within_range and doublehit_check:
			var player_node = GetPlayer(player_id)
			if player_node:
				projectile.hit_players[player_id] = true
				player_node.DealDamage(projectile["damage"], projectile["enemy_name"])
				if not projectile.piercing: valid_collision = true
	
	return [valid_collision, projectile]

func ProjectileMovement(projectile, alive_time):
	if projectile.formula in cached_expressions:
		expression = cached_expressions[projectile.formula]
	else:
		expression.parse(projectile.formula, ["x"])
		cached_expressions[projectile.formula] = expression
	
	var velocity = projectile.direction.normalized() * projectile.speed
	var vertical_move_vector = projectile["speed"] * projectile["direction"] * tick_rate
	var perpendicular_vector = Vector2(-velocity.y, velocity.x)
	var horizontal_move_vector = perpendicular_vector * expression.execute([alive_time * 50]) * 0.05
	
	return [horizontal_move_vector, vertical_move_vector]

func HandleProjectile(projectile, projectile_id, time):
	var alive_time = (time / 1000) - projectile.start_time
	
	var move = ProjectileMovement(projectile, alive_time)
	projectile.path += move[1]
	projectile.projectile_position = projectile.path + move[0]
	
	var max_range = projectile.start_position.distance_to(projectile.path) >= projectile.tile_range * 8
	var result = ProjectileInteraction(projectile, projectile.projectile_position)
	var valid_collision = result[0]
	projectile = result[1]
	
	if max_range or valid_collision:
		projectile_list.erase(projectile_id)
		server.RemoveEnemyProjectile(projectile_id, self)
	else:
		projectile_list[projectile_id] = projectile

func EnemyTimers(effects, signals):
	for _effect in effects.keys():
		effects[_effect] -= tick_rate
		if effects[_effect] <= 0:
			effects.erase(_effect)
	
	for _signal in signals.keys():
		signals[_signal] -= tick_rate
		if signals[_signal] <= 0:
			signals.erase(_signal)
	
	return [effects, signals]

func EnemyNewPhase(enemy, phases):
	var phase_index = -1
	var possible_phases = []
	
	for phase in phases:
		phase_index += 1
		var health_ratio = (enemy.health / enemy.max_health) * 100
		var valid_health = health_ratio >= phase.health[0] and health_ratio <= phase.health[1] 
		
		var used_before = phase_index in enemy.used_phases
		var use_limit = "max_uses" in phase
		var on_signal = "on_signal" in phase
		var on_spawn = "on_spawn" in phase
		var possible = (
			not use_limit
			or not used_before
			or (
				used_before
				and phase.max_uses > enemy.used_phases[phase_index]
			)
		)
		
		if valid_health and possible: possible_phases.append(phase_index)
		if on_signal and valid_health and possible:
			var valid_signals = []
			var enemy_signals = enemy.signals
			
			for _signal in phase.on_signal: valid_signals.append(_signal in enemy_signals)
			if not false in valid_signals:
				possible_phases = [phase_index]
				break;
			else: continue
		elif on_signal: continue
		
		if on_spawn and valid_health and possible:
			possible_phases = [phase_index]
			break
	
	if len(possible_phases) > 0:
		var chosen_index = possible_phases[randi() % len(possible_phases)]
		var used_before = chosen_index in enemy.used_phases
		if used_before: enemy.used_phases[chosen_index] += 1
		else: enemy.used_phases[chosen_index] = 1
		if phase_index != chosen_index: phase_index = 0
		
		enemy.pattern_timer = 0
		enemy.pattern_index = 0
		enemy.phase_index = chosen_index
		enemy.phase_timer = phases[chosen_index].duration
		
		var phase = phases[chosen_index]
		
		if "behavior" in phase: enemy.behavior = phase.behavior
		if "speed" in phase: enemy.speed = phase.speed
	
	return enemy

func EnemyPattern(enemy, enemy_id, attack_pattern, time):
	var enemy_position = enemy.position
	var dead = "dead" in enemy and enemy.dead
	var attack = attack_pattern[enemy.pattern_index]
	
	var projectile = "projectile" in attack and not dead
	var summon = "summon" in attack and not arena
	var speech = "speech" in attack
	var effect = "effect" in attack
	var die = "dead" in attack
	var broadcast = "signal" in attack
	
	if projectile:
		var direction = attack.direction.normalized()
		
		if not "targeter" in attack: pass
		elif attack.targeter == "nearest":
			var closest = 24 * 8
			var players = player_list
			
			if use_chunks:
				var chunk = reference.CalculateChunk(enemy.position)
				var chunk_exists = chunk in reference.chunks
				players = reference.chunks[chunk].players if chunk_exists else players
			
			for player_id in players.keys():
				var player_position = players[player_id].position + Vector2(0,-4)
				if player_position.distance_to(enemy_position) <= closest:
					closest = player_position.distance_to(enemy_position)
					direction = enemy_position.direction_to(player_position)
					direction = OffsetProjectileAngle(direction, attack.direction)
			
			if closest >= 24 * 8:
				enemy.pattern_timer = attack.wait
				if enemy.pattern_index == len(attack_pattern) - 1: enemy.pattern_index = 0
				else: enemy.pattern_index += 1
				return enemy
		elif attack.targeter == "parent":
			if enemy.origin in enemy_list:
				var parent = enemy_list[enemy.origin].position + Vector2(0,-4)
				direction = enemy_position.direction_to(parent)
				direction = OffsetProjectileAngle(direction, attack.direction)
			else:
				enemy.pattern_timer = attack.wait
				if enemy.pattern_index == len(attack_pattern) - 1: enemy.pattern_index = 0
				else: enemy.pattern_index += 1
				return enemy
		
		var projectile_data = {
			"id" : str(projectile_id_counter),
			"name" : attack.projectile,
			"start_time" : time / 1000,
			"start_position" : enemy_position,
			"position" : enemy_position,
			"path" : enemy_position,
			"direction" : direction,
			"hit_players" : {},
			"size" : attack.size,
			"speed" : attack.speed,
			"damage" : attack.damage,
			"formula" : attack.formula,
			"piercing" : attack.piercing,
			"tile_range" : attack.tile_range,
		}
		
		EnemyProjectile(projectile_data, enemy_id)
	elif summon:
		var summon_position = attack.summon_position + enemy_position
		var flip = attack.flip if attack.has("flip") else -1
		SpawnEnemy(attack.summon, summon_position - position, enemy_id, flip)
	elif speech:
		server.Speech(enemy.name, enemy_id, attack.speech, name)
	elif effect:
		enemy.effects[attack.effect] = attack.duration
	elif die:
		enemy.dead = attack.dead
	elif broadcast:
		var signal_type = attack.signal
		var reciever = attack.reciever
		var duration = attack.duration
		var origin = enemy.origin
		
		if reciever == "parent" and origin in enemy_list:
			enemy_list[origin].signals[signal_type] = duration
		else:
			for _enemy_id in enemy_list.keys():
				if enemy_list[_enemy_id].name == reciever:
					enemy_list[_enemy_id].signals[signal_type] = duration
	
	enemy.pattern_timer = attack.wait
	if enemy.pattern_index == len(attack_pattern) - 1: enemy.pattern_index = 0
	else: enemy.pattern_index += 1
	return enemy

func EnemyBehavior(enemy, enemy_id, phases, time):
	if len(phases) > 0:
		var phase = phases[enemy.phase_index]
		var health_ratio = (enemy.health / enemy.max_health) * 100
		var valid_health = health_ratio >= phase.health[0] and health_ratio <= phase.health[1]
		var signal_restriction = "on_signal" in phase
		var valid_signal = true
		
		if signal_restriction:
			var phase_signal = phase.on_signal[0]
			var has_signal = phase_signal in enemy.signals
			var spider = "initiate_legs" == phase_signal or "legs_alive" == phase_signal
			valid_signal = spider or has_signal
		
		enemy.pattern_timer -= tick_rate
		enemy.phase_timer -= tick_rate
		
		if not valid_health or not valid_signal or enemy.phase_timer <= 0:
			enemy.phase_timer = 0
			enemy = EnemyNewPhase(enemy, phases)
			phase = phases[enemy.phase_index]
		
		var loops = 0
		while enemy.pattern_timer <= 0 and loops < 72:
			loops += 1
			enemy = EnemyPattern(enemy, enemy_id, phase.attack_pattern, time)
	return enemy

func HandleEnemy(enemy, enemy_id, time):
	var enemy_data = ServerData.GetEnemy(enemy.name)
	
	if "health_scaling" in enemy_data:
		var ratio = enemy.health / enemy.max_health
		enemy.max_health = len(player_list.keys()) * enemy_data.health_scaling + enemy_data.health
		enemy.health = enemy.max_health * ratio
	
	var timers = EnemyTimers(enemy.effects, enemy.signals)
	enemy.effects = timers[0]
	enemy.signals = timers[1]
	
	var phases = enemy_data.phases
	enemy = EnemyBehavior(enemy, enemy_id, phases, time)
	
	if enemy.health < 1 and not use_chunks:
		if not arena: CalculateLootPool(enemy_list[enemy_id], enemy_id)
		else: CalculateLootPool(enemy_list[enemy_id], enemy_id, true, "building_materials")
		enemy_list.erase(enemy_id)
		return
	
	if "dead" in enemy_data and "dead" in enemy_data: pass
	elif (enemy.behavior == 0): enemy = Behaviors.Stationary(enemy, tick_rate, reference)
	elif (enemy.behavior == 1): enemy = Behaviors.Wander(enemy, tick_rate, reference)
	elif (enemy.behavior == 2): enemy = Behaviors.Chase(enemy, tick_rate, reference)
	elif (enemy.behavior == 3): enemy = Behaviors.Rotate(enemy, tick_rate, reference)
	
	enemy_list[enemy_id] = enemy

func _physics_process(delta):
	running_time += delta
	if not get_world_2d() or not get_parent(): return
	
	for i in range(floor((running_time - last_tick) / tick_rate)):
		var time = OS.get_system_time_msecs()
		
		for projectile_id in projectile_list.keys():
			var projectile = projectile_list[projectile_id]
			HandleProjectile(projectile, projectile_id, time)
		
		for enemy_id in enemy_list.keys():
			var enemy = enemy_list[enemy_id]
			HandleEnemy(enemy_list[enemy_id], enemy_id, time)
		
		if use_chunks == false:
			last_tick = running_time

func RemovePlayer(player_id):
	var player_container = GetPlayer(player_id)
	
	player_list.erase(str(player_id))
	
	if self in server.player_instance_tracker:
		server.player_instance_tracker[self].erase(player_id)
	if player_container:
		players_node.remove_child(player_container)

func SpawnPlayer(player_container):
	if is_instance_valid(player_container):
		var username = "[unset]"
		var player_id = int(player_container.name)
		player_container.instance = self
		server.player_instance_tracker[self].append(player_id)
		
		if player_container.account_data:
			username = player_container.account_data.username
		
		player_list[player_container.name] = {
			"name": username,
			"level": 0,
			"status_effects" : [],
			"position": player_container.position,
			"animation": { "animation" : "Idle", "direction" : Vector2.ZERO },
			"sprite": {
				"rect" : Rect2(Vector2(0,0), Vector2(80,40)),
				"class" : "Apprentice",
				"gear" : {},
				"level" : 0
			}
		}
		players_node.add_child(player_container)

func UpdatePlayer(player_id, player_state, fake = false):
	var player_container = players_node.get_node_or_null(str(player_id))
	var id = str(player_id)
	
	if player_container:
		player_list[id].fake = fake
		player_list[id].position = player_state.position
		player_list[id].animation = player_state.animation
		player_list[id].sprite = player_state.sprite
		
		player_container.position = player_list[str(player_id)]["position"]
		player_container.last_updated = OS.get_system_time_secs()
		
		var space_state = get_world_2d().direct_space_state
		var collision = space_state.intersect_point(player_list[str(player_id)]["position"]+position, 1, [], 1, true, true)
		var colliding = collision.size() > 0
		
		if colliding:
			for collision_data in collision:
				if collision_data.collider.name == "TileMap":
					#server.html_network.disconnect_peer(int(player_id))
					break

func GetPlayer(player_id):
	return players_node.get_node_or_null(str(player_id))

func EnemyProjectile(projectile_data, enemy_id):
	projectile_data.enemy_id = enemy_id
	projectile_data.enemy_name = enemy_list[enemy_id].name
	projectile_list[projectile_id_counter] = projectile_data
	
	if projectile_id_counter <= 2174000: projectile_id_counter += 1
	else: projectile_id_counter = 0
	
	server.EnemyProjectile(projectile_data, self, enemy_id)

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction

func SpawnLootBag(_loot, player_id, position):
	var loot_id = "loot " + server.generate_unique_id()
	var soulbound = false
	var loot_bag_tier = 0
	var loot = [
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
	]
	
	if player_id != null:
		var highest_loot_tier = 0
		var loot_bag_tier_translation = {
			0 : 0,
			1 : 0,
			2 : 1,
			3 : 1,
			4 : 2,
			5 : 2,
			6 : 3,
		}
		
		var i = 0
		for raw_item in _loot:
			loot[i] = raw_item
			i += 1
			var item = ServerData.GetItem(raw_item.item)
			if int(item.tier) > highest_loot_tier:
				highest_loot_tier = int(item.tier)
			elif item.tier == "UT":
				highest_loot_tier = 6
		loot_bag_tier = loot_bag_tier_translation[highest_loot_tier]
		
		if loot_bag_tier > 1:
			soulbound = true
	else:
		var i = 0
		for raw_item in _loot:
			loot[i] = raw_item
			i += 1
	
	object_list[loot_id] = {
		"name": "Bag"+str(loot_bag_tier),
		"soulbound": soulbound,
		"tier": loot_bag_tier,
		"loot": loot,
		"player_id": str(player_id),
		"type": "LootBags",
		"end_time": OS.get_system_time_msecs() + 40000,
		"position": position
	}
	
	if portal_name is String and "tutorial" in portal_name:
		object_list[loot_id].end_time = 2 * OS.get_system_time_msecs()

class SortByValue:
	static func sort_ascending(a, b):
		if a[1] < b[1]:
			return true
		return false

var rng = RandomNumberGenerator.new()
func CalculateLootPool(enemy, enemy_id, template = false, type = null):
	rng.randomize()
	var enemy_name = enemy.name
	var enemy_data = ServerData.GetEnemy(enemy_name)
	var templates = {
		"building_materials" : {
			"soulbound_loot" : [
				{
					"item" : 1,
					"chance" : 20,
					"threshold" : 0.1,
				},
				{
					"item" : 2,
					"chance" : 40,
					"threshold" : 0.1,
				},
			],
			"loot" : []
		},
	}
	
	if not template and ServerData.GetEnemy(enemy_name).has("dungeon") and randf() < ServerData.GetEnemy(enemy_name).dungeon.rate:
		OpenPortal(ServerData.GetEnemy(enemy_name).dungeon.name, enemy.position)
	
	var player_pool = enemy["damage_tracker"]
	var loot_pool = enemy_data.loot_pool
	if template and templates.has(type):
		loot_pool = templates[type]
	
	if not template:
		#Handle EXP
		var exp_amount = enemy_data.exp
		for player_id in player_pool.keys():
			var player_container = get_node("YSort/Players/"+str(player_id))
			if not player_container:
				player_pool.erase(player_id)
			else:
				player_container.AddExp(exp_amount, enemy["name"], enemy_id)
	
	#Handle loot drops
	var ordered_pairs = []
	for player_id in player_pool.keys():
		ordered_pairs.append([player_id, player_pool[player_id]])
	
	ordered_pairs.sort_custom(SortByValue, "sort_ascending")
	
	var loot_bags = []
	var i = 0
	
	#Soulbound loot
	for pair in ordered_pairs:
		var player_id = pair[0]
		var damage_percent = pair[1]/enemy["max_health"]
		var loot_bag = {
			"player_id" : player_id,
			"loot" : []
		}
		
		for item in loot_pool.soulbound_loot:
			if rng.randi_range(1,item.chance) == item.chance and damage_percent > item.threshold:
				loot_bag.loot.append({
					"item" : item.item,
					"id" : server.generate_unique_id()
				})
		if loot_bag.loot != []:
			loot_bags.append(loot_bag)
	
	#Non soulbound loot
	var loot_bag = {
		"player_id" : null,
		"loot" : []
	}
	for item in loot_pool.loot:
		if rng.randi_range(1,item.chance) == item.chance:
			loot_bag.loot.append({
				"item" : item.item,
				"id" : server.generate_unique_id()
			})
	if loot_bag.loot != []:
			loot_bags.append(loot_bag)
	
	if loot_pool.has("one_person_loot") and rng.randi_range(1,loot_pool.one_person_loot.chance) == loot_pool.one_person_loot.chance:
		loot_bags[randi() % len(loot_bags)].loot.append({
			"item" : loot_pool.one_person_loot.item,
			"id" : server.generate_unique_id()
		})
	
	var loot_position = enemy.position + enemy_data.loot_offset if enemy_data.has("loot_offset") else enemy.position
	
	if not "tutorial" in name or "tutorial" in enemy_name:
		for _loot_bag in loot_bags:
			SpawnLootBag(_loot_bag.loot, _loot_bag.player_id, loot_position + Vector2(rand_range(-3,3), rand_range(-3,3)))

func _compare_values(a, b):
	return a[1] - b[1]

var taken_points = []
func GetBoatSpawnpoints():
	var room_size = 50
	var res = []
	
	for x in range(-room_size, room_size*2):
		for y in range(-room_size, room_size*2):
			var current_tile = $TileMap.get_cell(x,y)
			var current_position = Vector2(x*8, y*8) - position + Vector2(4,4)
			
			if current_tile == 13:
				res.append(current_position)
	
	var index = round(rand_range(0, res.size()-1))
	var count = 0
	while(taken_points.has(index)):
		count += 1
		index = round(rand_range(0, res.size()-1))
		if count > 100:
			return res[0]
	taken_points.append(index)
	return res[index]

func OpenPortal(portal_name, position, map_size = Vector2(750,750), ruler = null, which = null):
	var instance_id = server.generate_unique_id()
	
	if "island" in portal_name:
		instance_id = portal_name + " " + instance_id
		var island_instance
		
		if GameplayLoop.island_preloads.has(map_size):
			var islands = GameplayLoop.island_preloads[map_size]
			var boilerplate_island_instance = islands[randi() % len(islands)]
			island_instance = boilerplate_island_instance.duplicate()
			island_instance.server = boilerplate_island_instance.server
			island_instance.map_size = boilerplate_island_instance.map_size
			island_instance.spawn_points = boilerplate_island_instance.spawn_points
			island_instance.tile_points = boilerplate_island_instance.tile_points
			island_instance.map_as_array = boilerplate_island_instance.map_as_array.duplicate(true)
			island_instance.map_objects = boilerplate_island_instance.map_objects
			island_instance.enemy_spawn_points = boilerplate_island_instance.enemy_spawn_points
		else:
			island_instance = load("res://Scenes/SupportScenes/Island/Island.tscn").instance()
			if portal_name == "special_island":
				island_instance = load("res://Scenes/SupportScenes/Island/SpecialIsland.tscn").instance()
		
			island_instance.server = server
			island_instance.map_size = map_size
			island_instance.GenerateIslandMap()
			GameplayLoop.island_preloads[map_size] = [island_instance.duplicate()]
		
		if portal_name == "special_island":
			portal_name = "island"
			island_instance.which = which
		
		island_instance.ruler = ruler
		island_instance.name = instance_id
		object_list[instance_id] = {
			"name": portal_name,
			"ruler": ruler,
			"type": "DungeonPortals",
			"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
			"position": position,
		}
		
		island_instance.position = Instances.GetFreeInstancePosition()
		add_child(island_instance)
		return island_instance
	elif "house" in portal_name:
		object_list[instance_id] = {
			"name": "house",
			"type": "DungeonPortals",
			"end_time": 2 * OS.get_system_time_msecs(),
			"position": position
		}
	else:
		instance_id =  "dungeon " + portal_name + instance_id
		var instance_map = Dungeons.GenerateDungeon(portal_name)
		var tile_translation = ServerData.dungeons[portal_name].tile_translation
		var dungeon_instance = load("res://Scenes/SupportScenes/Dungeons/Dungeon.tscn").instance()
		
		dungeon_instance.name = instance_id
		dungeon_instance.map = instance_map
		dungeon_instance.dungeon_name = portal_name
		dungeon_instance.portal_name = portal_name
		dungeon_instance.room_size = ServerData.dungeons[portal_name].room_size
		dungeon_instance.tile_translation = tile_translation
		dungeon_instance.position = Instances.GetFreeInstancePosition()
		
		if ServerData.dungeons[portal_name].has("dungeon_boss"):
			dungeon_instance.dungeon_boss = ServerData.dungeons[portal_name].dungeon_boss
		
		object_list[instance_id] = {
			"name": portal_name,
			"type": "DungeonPortals",
			"end_time": OS.get_system_time_msecs() + 30000,
			"position": position
		}
		
		add_child(dungeon_instance)
		return dungeon_instance

func SpawnEnemy(enemy_name, spawn_position, origin = "player", flip = -1):
	var enemy_id = server.generate_unique_id()
	var enemy_data = ServerData.GetEnemy(enemy_name)
	var corrected_spawn_position = spawn_position + position
	var valid_anchor = (
		"anchor" in enemy_data
		and enemy_data.anchor == "parent"
		and origin in enemy_list
	)
	var anchor = enemy_list[origin].position if valid_anchor else corrected_spawn_position
	
	
	enemy_list[str(enemy_id)] = {
		"name": enemy_name,
		"position": corrected_spawn_position,
		"health": enemy_data.health,
		"max_health": enemy_data.health,
		"defense": enemy_data.defense,
		"state": "Idle",
		"flip" : flip,
		
		"behavior": enemy_data.behavior,
		"current_direction" : null,
		"last_position" : Vector2.ZERO,
		"stuck_timer" : 5,
		
		"speed":enemy_data.speed,
		"exp": enemy_data.exp,
		"damage_tracker": {},
		"target": corrected_spawn_position,
		"anchor_position": anchor,
		"origin" : origin,
		"effects" : {},
		"signals" : {},
		
		"pattern_index" : 0,
		"pattern_timer" : 0,
		"phase_index" : 0,
		"phase_timer" : 0,
		"used_phases" : {},
		"dead" : false
	}

func SpawnNPC(npc_name, spawn_position):
	object_list[npc_name] = {
		"name": npc_name,
		"type":"Npcs",
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"position": spawn_position,
		"instance": self
	}
