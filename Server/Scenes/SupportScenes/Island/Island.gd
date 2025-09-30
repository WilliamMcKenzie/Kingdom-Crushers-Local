extends "res://Scenes/Main/Map.gd"

export var map_size = Vector2(780,780)
export var ruler = ""
var ruler_id
var ruler_spawned = false
var ruler_death_position = Vector2.ZERO
var noise
var chunk_size = 16
var tile_cap = 0.5
var environment_caps = Vector3(0.4, 0.3, 0.04)
var player_spawnpoint_tile_id = 2
var map_as_array = []
var map_objects = {}
var spawn_points = []
var tile_points = {}
var enemy_spawn_points = {}
var beach_enemies = ["crab", "slime"]
var forest_enemies = ["goblin_cannon", "nature_druid", "slime"]
var plains_enemies = ["troll_king", "cyclops_leader", "imp_warrior", "blue_slime", "fire_druid"]
var badlands_enemies = ["rat_king", "viking_king", "yellow_slime", "shadow_druid"]
var mountain_enemies = ["cacodemon", "basalisk", "phoenix", "archmage"]
var chunks = {}
var loaded_chunks = {}
var empty_chunk = {
	"enemies" : {},
	"players" : {},
	"objects" : {},
}

var timer = 0
var island_close_timer = 5
var island_closed = false

func HandleRuler(delta):
	if not ruler:
		return
	
	if island_closed and get_child_count() == 3:
		server.player_instance_tracker.erase(self)
		queue_free()
	
	ruler_id = null
	
	for enemy_id in enemy_list:
		var enemy = enemy_list[enemy_id]
		
		if enemy.name == ruler and (not "dead" in enemy or not enemy.dead):
			ruler_id = enemy_id
		elif enemy.name == ruler:
			ruler_death_position = enemy.position
	
	if not ruler_id and not ruler_spawned and ServerData.GetEnemy(ruler):
		ruler_spawned = true
		SpawnEnemy(ruler, map_size / 2 * 8 - position)
	elif not ruler_id and ruler_spawned:
		island_close_timer -= delta * 60
	
	if island_close_timer <= 0 and not island_closed and "dungeon" in ServerData.GetEnemy(ruler):
		island_closed = true
		if ruler in GameplayLoop.bosses_status:
			GameplayLoop.bosses_status[ruler] = false
		GameplayLoop.Update()
		
		if get_parent().object_list.has(name):
			get_parent().object_list.erase(name)
		var dungeon = ServerData.GetEnemy(ruler).dungeon.name
		var instance_id = OpenPortal(dungeon, ruler_death_position)
		
		for player_id in player_list.keys():
			server.ForcedEnterInstance(instance_id, int(player_id))
	elif island_close_timer <= 0 and not ServerData.GetEnemy(ruler).has("dungeon"):
		island_close_timer = 30
		SpawnEnemy(ruler, map_size/2*8-position)

func HandleDeath(data, enemy_id):
	if data.health < 1:
		if data.name == ruler and "dungeon" in ServerData.GetEnemy(ruler):
			if not enemy_list[enemy_id].dead:
				for player_id in player_list.keys():
					players_node.get_node(player_id).GiveEffect("invincible", 10)
					server.Message(int(player_id), "system",  "%s's kingdom has been destroyed!" % [server.IdentifierToString(ruler)])
					server.rpc_id(int(player_id), "KingdomCrushed", ruler_id)
			
			enemy_list[enemy_id].dead = true
			enemy_list[enemy_id].pattern_timer = OS.get_system_time_msecs()
			enemy_list[enemy_id].pattern_timer = OS.get_system_time_msecs()
		else:
			CalculateLootPool(data, enemy_id)
			var chunk = CalculateChunk(data.position)
			var valid_chunk = (
				chunks.has(chunk)
				and chunks[chunk].enemies.has(enemy_id)
			)
			
			if valid_chunk: chunks[chunk].enemies.erase(enemy_id)
			enemy_list.erase(enemy_id)

func HandleChunks():
	for chunk in chunks: if IsChunkRadiusEmpty(chunk): for id in chunks[chunk].enemies.keys():
		var is_ruler = (
			enemy_list[id].origin == ruler_id
			or enemy_list[id].name == ruler
		)
		
		if not ruler or not is_ruler:
			enemy_list.erase(id)
			chunks[chunk].enemies.erase(id)

func _physics_process(delta):
	CheckChunks()
	
	use_chunks = true
	for i in range(floor((running_time - last_tick) / tick_rate)):
		for enemy_id in enemy_list.keys():
			var data = enemy_list[enemy_id]
			HandleDeath(data, enemy_id)
		last_tick = running_time
	
	timer += delta
	if timer > 1:
		timer = 0
		HandleRuler(delta)
		HandleChunks()

func IsChunkRadiusEmpty(chunk):
	var is_empty = true
	
	var offsets = [
		Vector2(0, 0),
		Vector2(chunk_size, 0),
		Vector2(chunk_size, chunk_size),
		Vector2(-chunk_size, 0),
		Vector2(-chunk_size, chunk_size),
		Vector2(0, chunk_size),
		Vector2(chunk_size, -chunk_size),
		Vector2(0, -chunk_size),
		Vector2(-chunk_size, -chunk_size)
	]
	
	for offset in offsets:
		if chunks.has(chunk + offset) and chunks[chunk + offset]["players"].size() != 0:
			is_empty = false
			break
	
	return is_empty

#Check if a position is within a chunk Vector2
func WithinChunk(chunk, pos):
	var enemy_coords = Vector2(round((pos/8).x), round((pos/8).y))
	var _chunk = Vector2(chunk_size*round((enemy_coords.x)/chunk_size), chunk_size*round((enemy_coords.y)/chunk_size))
	
	return _chunk == chunk

func CalculateChunk(pos):
	var enemy_coords = Vector2(round((pos/8).x), round((pos/8).y))
	var chunk = Vector2(chunk_size*round((enemy_coords.x)/chunk_size), chunk_size*round((enemy_coords.y)/chunk_size))
	
	return chunk

func GetMapSpawnpoint():
	randomize()
	return spawn_points[randi() % len(spawn_points)]

func GetIslandChunk(chunk):
	var result = []
	var objects = []
	var empty_chunk = IsChunkRadiusEmpty(chunk)
	
	var chunk_start = chunk.x - (chunk_size / 2)
	var chunk_end = chunk.x + (chunk_size / 2)
	for x in range(chunk_start, chunk_end):
		var column = []
		chunk_start = chunk.y - (chunk_size / 2)
		chunk_end = chunk.y + (chunk_size / 2)
		
		for y in range(chunk_start, chunk_end):
			if len(map_as_array) > x and len(map_as_array[x]) > y:
				var tile = Vector2(x * 8, y * 8)
				var coordinate = Vector2(x, y)
				
				column.append(map_as_array[x][y])
				if tile in map_objects: objects.append(map_objects[tile])
				if coordinate in enemy_spawn_points and empty_chunk:
					var selection = enemy_spawn_points[coordinate].selection
					var enemy_index = round(rand_range(0, selection.size() - 1))
					
					if len(selection) > 0 and Behaviors.DetermineCollisionSafePoint(tile, tile, self, selection[enemy_index]):
						SpawnEnemy(selection[enemy_index], tile - position)
		result.append(column)
	return {
		"tiles" : result,
		"objects" : objects
	}

func GetChunkData(chunk):
	if chunk in chunks and not chunks[chunk].empty():
		return chunks[chunk]
	return empty_chunk

func _ready():
	if ruler and load("res://Scenes/SupportScenes/Island/Structures/" + ruler + ".tscn"):
		var setpiece = load("res://Scenes/SupportScenes/Island/Structures/" + ruler + ".tscn").instance()
		CreateStructure(setpiece, Vector2(round(map_size.x/2), round(map_size.y/2)))
		setpiece.queue_free()

func GenerateIslandMap():
	if get_script().resource_path.get_file().get_basename() == "TutorialIsland" and has_method("TutorialInit"):
		reference.TutorialInit()
	if get_script().resource_path.get_file().get_basename() == "SpecialIsland" and has_method("SpecialInit"):
		reference.SpecialInit()
	
	noise = OpenSimplexNoise.new()
	noise.octaves = 1.0
	noise.period = 12
	HandleTiles()
	HandleSpawnpoints()
	HandleObstacles()

func HandleTiles():
	var center = map_size / 2
	var ocean_distance = center.length() * 1.5
	var beach_distance = center.length() * 1.25
	var forest_distance = center.length() * 1.2
	var plains_distance = center.length() * 1
	var badlands_distance = center.length() * 0.8
	var mountains_distance = center.length() * 0.5
	
	#For wavy edges of island
	var noise_scale = 0.6
	var noise_intensity = 0.05
	
	for x in range(map_size.x):
		map_as_array.append([])
		for y in range(map_size.y):
			var distance = (Vector2(x, y) - center).length()
			var noise_offset = rand_range(0,0.03)

			#Base value for a perfect circle
			var ocean_value = 1.0 - (distance / ocean_distance)
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			
			var beach_value = (1.0 - (distance / beach_distance)) + noise_value/3
			var forest_value = (1.0 - (distance / forest_distance)) + noise_value/3
			var plains_value = (1.0 - (distance / plains_distance)) + noise_value/3 + noise_offset
			var badlands_value = (1.0 - (distance / badlands_distance)) + noise_value + noise_offset
			var mountains_value = (1.0 - (distance / mountains_distance)) + noise_value*2 + noise_offset
			
			if mountains_value > tile_cap:
				map_as_array[x].append(6)
			elif badlands_value > tile_cap:
				map_as_array[x].append(5)
			elif plains_value > tile_cap:
				map_as_array[x].append(4)
			elif forest_value > tile_cap:
				map_as_array[x].append(3)
			elif beach_value > tile_cap:
				map_as_array[x].append(2)
			elif ocean_value > tile_cap:
				map_as_array[x].append(1)
			else:
				map_as_array[x].append(0)
	
	var structures = ["ruins_0", "ruins_1", "ruins_2"]
	for x in range(0, map_size.x, chunk_size):
		for y in range(0, map_size.y, chunk_size):
			var tile = map_as_array[x][y]
			var structure_seed = randf()
			var structure_index = round(rand_range(0, structures.size()-1))
			if tile == 6 and structure_seed < 0.3:
				var structure = load("res://Scenes/SupportScenes/Island/Structures/" + structures[structure_index] + ".tscn").instance()
				CreateStructure(structure, Vector2(x,y))
				structure.queue_free()

func CreateStructure(structure, placement):
	var tile_map = $TileMap
	
	for x in range(-32, 32*2):
		for y in range(-32, 32*2):
			var current_tile = structure.get_cell(x,y)
			
			if current_tile > -1:
				var pos = Vector2(x + placement.x, y + placement.y)
				if map_objects.has(Vector2(pos.x*8, pos.y*8)):
					map_objects.erase(Vector2(pos.x*8, pos.y*8))
				map_as_array[pos.x][pos.y] = current_tile
				tile_map.set_cell(pos.x, pos.y, map_as_array[pos.x][pos.y])

var chunk_timer = 0
func CheckChunks():
	chunk_timer += 1
	if chunk_timer >= 60:
		chunk_timer = 0
		chunks = {}
		for player_id in player_list.keys():
			var chunk = CalculateChunk(player_list[player_id].position)
			if not chunks.has(chunk):
				chunks[chunk] = {}
				chunks[chunk].players = {}
				chunks[chunk].enemies = {}
				chunks[chunk].objects = {}
			chunks[chunk].players[player_id] = player_list[player_id]
		for enemy_id in enemy_list.keys():
			var chunk = CalculateChunk(enemy_list[enemy_id].position)
			if not chunks.has(chunk):
				chunks[chunk] = {}
				chunks[chunk].players = {}
				chunks[chunk].enemies = {}
				chunks[chunk].objects = {}
			chunks[chunk].enemies[enemy_id] = enemy_list[enemy_id]
		for object_id in object_list.keys():
			var chunk = CalculateChunk(object_list[object_id].position)
			if not chunks.has(chunk):
				chunks[chunk] = {}
				chunks[chunk].players = {}
				chunks[chunk].enemies = {}
				chunks[chunk].objects = {}
			chunks[chunk].objects[object_id] = object_list[object_id]

func HandleSpawnpoints():
	var spawn_point_index = 0
	for x in range(map_size.x):
		for y in range(map_size.y):
			var map_tile = map_as_array[x][y]
			var spawnpoint_tile = x%12 == 0 and y%12 == 0
			var spawnpoint_position = Vector2(x + round(rand_range(-4, 4)), y + round(rand_range(-4, 4)))
			
			if tile_points.has(map_tile):
				tile_points[map_tile].append(Vector2(x*8, y*8))
			else:
				tile_points[map_tile] = [Vector2(x*8, y*8)] 
			if map_tile == player_spawnpoint_tile_id:
				spawn_points.append(Vector2(x*8, y*8))
			
			#tile_map.set_cell(x, y, map_as_array[x][y])
			if not spawnpoint_tile:
				continue
			elif map_tile == 2:
				enemy_spawn_points[spawnpoint_position] = { "index": spawn_point_index, "alive":false, "selection":beach_enemies}
				spawn_point_index += 1
			elif map_tile == 3:
				enemy_spawn_points[spawnpoint_position] = { "index": spawn_point_index, "alive":false, "selection":forest_enemies}
				spawn_point_index += 1
			elif map_tile == 4:
				enemy_spawn_points[spawnpoint_position] = { "index": spawn_point_index, "alive":false, "selection":plains_enemies}
				spawn_point_index += 1
			elif map_tile == 5:
				enemy_spawn_points[spawnpoint_position] = { "index": spawn_point_index, "alive":false, "selection":badlands_enemies}
				spawn_point_index += 1
			elif map_tile == 6:
				enemy_spawn_points[spawnpoint_position] = { "index": spawn_point_index, "alive":false, "selection":mountain_enemies}
				spawn_point_index += 1

func HandleObstacles():
	randomize()
	var obstacle_small = load("res://Scenes/SupportScenes/Obstacles/Small.tscn")
	var chance = 1.0
	var obstacles = {
		3 : [
			"tree1",
			"shrub1",
			"shrub2",
		],
		4 : [
			"rock4",
			"rock3",
		],
		5 : [
			"shroom1",
			"shroom2",
		],
		6 : [
			"rock1",
			"rock2",
			"twig1",
		]
	}
	
	for x in range(map_size.x):
		for y in range(map_size.y):
			var map_tile = map_as_array[x][y]
			var obstacle_seed = rand_range(0, 100)
			
			if obstacles.has(map_tile):
				var obstacle_list = obstacles[map_tile]
				
				var i = 0
				for obstacle in obstacle_list:
					i += 1
					if obstacle_seed < chance*i and not enemy_spawn_points.has(Vector2(x, y)):
						CreateObstacle(obstacle, Vector2(x, y), name)
						break

func CreateObstacle(obstacle_name, obstacle_position, island_id):
	var obstacle_id = server.generate_unique_id()
	$TileMap.set_cell(obstacle_position.x, obstacle_position.y - 1, 7)
	
	map_objects[Vector2(obstacle_position.x*8, obstacle_position.y*8)] = {
		"position": Vector2((obstacle_position.x * 8) + 4, (obstacle_position.y * 8) + 6),
		"name": obstacle_name, 
		"type": "Obstacles"
	}
