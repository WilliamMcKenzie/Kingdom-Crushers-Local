extends YSort

var player_node = load("res://Scenes/MainScenes/Instances/Components/Player/PlayerTemplate.tscn")
var enemy_node = load("res://Scenes/MainScenes/Instances/Components/Enemy/Enemy.tscn")
var object_nodes = {}

onready var players_node = get_node("YSort/OtherPlayers")
onready var enemies_node = get_node("YSort/Enemies")
onready var object_node = get_node("YSort/Objects")
onready var object_types = {
	"DungeonPortals" : object_node.get_node("DungeonPortals"),
	"LootBags" : object_node.get_node("LootBags"),
	"Buildings" : object_node.get_node("Buildings"),
	"Obstacles" : object_node.get_node("Obstacles"),
	"Npcs" : object_node.get_node("Npcs"),
}

var world_state_buffer = []
var last_world_state = 0
var object_list = {}
var player_list = []
var enemy_list = []
var timer = 0

func SetPlayer(player):
	var current = get_node_or_null("YSort/Player")
	
	if current:
		get_node("YSort").remove_child(current)
		current.queue_free()
	
	get_node("YSort").add_child(player)

func GetPlayer(player_id = Server.client_id):
	player_id = str(player_id)
	if player_id == str(Server.client_id):
		return get_node_or_null("YSort/Player")
	else:
		return players_node.get_node_or_null(player_id)

func GetEnemy(enemy_id):
	return enemies_node.get_node_or_null(str(enemy_id)) if enemies_node else null

func _physics_process(delta):
	if GameHandler.is_dead: return
	
	var render_time = Server.client_clock - 100
	timer += 1
	
	if world_state_buffer.size() > 1:
		while(world_state_buffer.size() > 3):
			world_state_buffer.remove(0)
		if world_state_buffer.size() > 2:
			if timer > 10:
				RefreshEnemies(world_state_buffer[2].enemies)
				RefreshPlayers(world_state_buffer[2].players)
				RefreshObjects(world_state_buffer[2].objects)
				timer = 0
			
			var time_1 = world_state_buffer[1].time
			var time_2 = world_state_buffer[2].time
			var interpolation_factor = float(render_time - time_1) / max(float(time_2 - time_1), 0.01)
			var lost = 0
			
			interpolation_factor = min(interpolation_factor, 2)
			
			for player_id in world_state_buffer[2].players.keys():
				var players_1 = world_state_buffer[1].players
				var players_2 = world_state_buffer[2].players
				
				var player_data_1 = players_1[player_id] if player_id in players_1 else null
				var player_data_2 = players_2[player_id] if player_id in players_2 else null
				
				var current_player = player_id == str(get_tree().get_network_unique_id())
				var other_player = players_node.get_node_or_null(str(player_id))
				
				if current_player or not player_data_1 or not player_data_2: continue;
				elif other_player:
					var new_position = lerp(player_data_1.position, player_data_2.position, interpolation_factor)
					other_player.MovePlayer(new_position, player_data_2)
					other_player.UpdateStatusEffects(player_data_2.status_effects)
				else:
					SpawnNewPlayer(player_id, player_data_2)
			
			for enemy_id in world_state_buffer[2].enemies.keys():
				var data = world_state_buffer[2].enemies[enemy_id]
				var enemy = enemies_node.get_node_or_null(str(enemy_id))
				
				if not data:
					pass
				elif enemy:
					enemy.effects = data.effects
					enemy.MoveEnemy(data.position, data.target, data.speed)
					if "dead" in data: enemy.death_stance = data.dead
				else:
					SpawnNewEnemy(enemy_id, data.position, data.name)

func Update(world_state):
	if world_state.time > last_world_state:
		last_world_state = world_state.time
		world_state.time = Server.client_clock
		world_state_buffer.append(world_state)

func SpawnNewEnemy(enemy_id, enemy_position, enemy_name):
	for enemy in enemies_node.get_children():
		if not enemy.active:
			enemy.name = enemy_id
			enemy.position = enemy_position
			enemy.Activate(enemy_name)
			enemy_list.append(enemy_id)
			return
	CreateEnemy(30)
	SpawnNewEnemy(enemy_id, enemy_position, enemy_name)

func CreateEnemy(amount):
	for i in range(amount):
		var enemy = enemy_node.instance()
		enemy.name = str(i)
		enemies_node.add_child(enemy)

func SpawnNewPlayer(id, data):
	var current_player = get_tree().get_network_unique_id() == int(id)
	var position = data.position
	var classname = data.sprite.class
	
	if not current_player and not id in player_list:
		var player_instance = player_node.instance()
		player_instance.name = str(id)
		player_instance.position = position
		player_instance.player_data = data
		players_node.add_child(player_instance)
		player_list.append(id)


func RefreshEnemies(enemies):
	for id in enemy_list:
		if not id in enemies:
			GetEnemy(id).DeActivate()
			enemy_list.erase(id)

func RefreshPlayers(players):
	for id in player_list:
		if not id in players:
			GetPlayer(id).queue_free()
			player_list.erase(id)

func RefreshObjects(objects):
	var expiring_types = [
		"DungeonPortals",
		"LootBags",
		"Buildings",
	]
	
	for id in objects.keys():
		if id in object_list: continue
		
		var data = objects[id]
		var scene_name = data.name + ".tscn"
		var type = data.type
		var container = object_types[type]
		var private_loot = (
			type == "LootBags"
			and data.soulbound
			and not "permanent" in data
			and data.player_id != str(Server.get_tree().get_network_unique_id())
		)
		
		if private_loot: continue
		elif not id in object_list:
			if not scene_name in object_nodes: object_nodes[scene_name] = load("res://Scenes/MainScenes/Instances/Components/Objects/" + type + "/" + scene_name)
			var instance = object_nodes[scene_name].instance()
			
			if data.position is String:
				var coordinates = data.replace("(","").replace(")","").split(",")
				var x = int(coordinates[0])
				var y = int(coordinates[1])
				data.position = Vector2(x, y)
			
			instance.name = id
			instance.object_id = id
			instance.position = data.position
			
			if type == "DungeonPortals":
				if data.name == "island" and data.ruler:
					instance.portal_name = data.ruler + "'s_kingdom"
					instance.ruler = data.ruler
				elif data.name == "island":
					instance.portal_name = "training_kingdom"
					instance.ruler = null
				else:
					instance.portal_name = data.name
			elif type == "LootBags":
				if data.name == "Bag2" or data.name == "Bag3": AudioHandler.Play("loot")
				instance.loot = data.loot
			
			object_list[id] = {
				"instance" : instance,
				"type" : type
			}
			container.add_child(instance)
	
	for id in object_list.keys():
		var type = object_list[id].type
		var expiring = type in expiring_types
		
		if expiring and not id in objects:
			object_list[id].instance.queue_free()
			object_list.erase(id)
		elif type == "LootBags":
			object_list[id].instance.UpdateLoot(objects[id].loot)
