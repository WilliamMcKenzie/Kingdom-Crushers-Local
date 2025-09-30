extends "res://Scenes/Main/Map.gd"

var player_id
var player_container

var open_mode = "closed"
var tiles = []

var timer = 0
func _physics_process(delta):
	timer += 1
	if timer > 20:
		timer = 0
		for object_id in object_list.keys():
			var object = object_list[object_id]
			if object.name == "apprentice_statue":
				GiveStatueBuff(object, "health", 10, 300)
			if object.name == "noble_statue":
				GiveStatueBuff(object, "defense", 1, 300)
			if object.name == "nomad_statue":
				GiveStatueBuff(object, "speed", 1, 300)
			if object.name == "scholar_statue":
				GiveStatueBuff(object, "vitality", 1, 300)
			if object.name == "dragon_statue":
				GiveStatueBuff(object, "dexterity",5,300)
			if object.name == "elemental_orb":
				GiveStatueBuff(object,"attack",5,300)

func GiveStatueBuff(object, buff, amount, time):
	for player_id in player_list.keys():
		if player_list[player_id]["position"].distance_to(object["position"]) <= 30:
			var player_container = get_node("YSort/Players/"+str(player_id))
			player_container.GiveBuff(amount, buff, time)

func AccountData(account_data):
	var house_data = account_data.home
	object_list = {}
	open_mode = house_data.open_mode
	tiles = house_data.tiles
	
	var index = -1
	for object in house_data.objects:
		index += 1
		if not ServerData.GetBuilding(object.type):
			pass
		elif ServerData.GetBuilding(object.type).catagory == "storage":
			CreateStorage(object, index)
		elif ServerData.GetBuilding(object.type).catagory == "statue":
			CreateStatue(object, index)

func CreateStorage(object, index):
	var storage_id = "loot " + server.generate_unique_id() + " " + str(index)
	if object.position is String:
		var vector2_position = Vector2.ZERO
		object.position = object.position.replace("(","").replace(")","").replace(",","").split(" ")
		vector2_position.x = float(object.position[0])
		vector2_position.y = float(object.position[1])
		object.position = vector2_position
	object_list[storage_id] = {
		"name": object.type,
		"permanent":true,
		"index" : index,
		
		"soulbound": true,
		"tier": 0,
		"loot": object.loot,
		"player_id": str(player_id),
		"type": "LootBags",
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"position": object.position,
	}

func CreateStatue(object, index):
	var statue_id = "statue " + server.generate_unique_id() + " " + str(index)
	if object.position is String:
		var vector2_position = Vector2.ZERO
		object.position = object.position.replace("(","").replace(")","").replace(",","").split(" ")
		vector2_position.x = float(object.position[0])
		vector2_position.y = float(object.position[1])
		object.position = vector2_position
	object_list[statue_id] = {
		"name": object.type,
		"index" : index,
		
		"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
		"type" : "Buildings",
		"position": object.position
	}

func ToggleState():
	open_mode = "closed" if open_mode == "open" else "open"
		
	var house_data = player_container.account_data.home
	house_data.open_mode = open_mode
	server.rpc_id(player_id, "HouseData", house_data, true)

func RemoveBuilding(_position):
	var house_data = player_container.account_data.home
	house_data.tiles = tiles
	
	for object_id in object_list.duplicate().keys():
		var object = object_list[object_id]
		#Update the accountdata to save it to the database
		if ServerData.buildings.has(object.name):
			var items = false
			if object.type == "LootBags":
				for item in object.loot:
					if item:
						items = true
			
			if (object.position.distance_to(_position) < 5) and not items:
				var type = object.name
				var building = ServerData.GetBuilding(type)
				player_container.account_data.home.inventory[building.type+"s"][type] += 1
				object_list.erase(object_id)
			elif object.position.distance_to(_position) < 5:
				server.Message(player_id, "error", "Empty storage first!")
	
	SaveData()
	server.rpc_id(player_id, "HouseData", house_data, true)

func PlaceBuilding(_type, _position):
	var building_data = ServerData.GetBuilding(_type)
	var house_data = get_node("YSort/Players/"+str(player_id)).account_data.home
	if not building_data:
		return
	elif building_data.type == "object" and house_data.inventory.objects[_type] > 0:
		if building_data.catagory == "storage":
			var loot = []
			for slot in building_data.loot_slots:
				loot.append(null)
			var new_storage = {
				"type" : _type,
				"position" : _position,
				"loot" : loot,
			}
			house_data.objects.append(new_storage)
			house_data.inventory.objects[_type] -= 1
			CreateStorage(new_storage, house_data.objects.size()-1)
		if building_data.catagory == "statue":
			var new_statue = {
				"type" : _type,
				"position" : _position,
			}
			house_data.objects.append(new_statue)
			house_data.inventory.objects[_type] -= 1
			CreateStatue(new_statue, house_data.objects.size()-1)
	elif building_data.type == "tile" and house_data.tiles.size() > _position.x and house_data.tiles[_position.x].size() > _position.y:
		var previous_tile_type
		var previous_tile = house_data.tiles[_position.x][_position.y]
		var new_tile = building_data.tile
		
		for building in ServerData.buildings.keys():
			var tile_data = ServerData.buildings[building]
			if tile_data.has("tile") and tile_data.tile == previous_tile:
				previous_tile_type = building
				break;
		
		if house_data.inventory.tiles[_type] > 0:
			house_data.inventory.tiles[previous_tile_type] += 1
			house_data.inventory.tiles[_type] -= 1
			house_data.tiles[_position.x][_position.y] = new_tile
	server.rpc_id(player_id, "HouseData", house_data, true)
	for _player_id in server.player_instance_tracker[self]:
		server.rpc_id(_player_id, "HouseData", house_data, false)

func Craft(type):
	var inventory = player_container.character.inventory.duplicate()
	var house_data = player_container.account_data.home
	
	var building = ServerData.GetBuilding(type)
	
	#Check if craftable
	if not building.craftable:
		return
	
	#Check if building is maxed out
	if not house_data.inventory[building.type+"s"].has(type) or not house_data.inventory[building.type+"s"][type]:
		house_data.inventory[building.type+"s"][type] = 0
	if building.has("max"):
		var total = house_data.inventory[building.type+"s"][type]
		if not total:
			total = 0
		for _building in house_data[building.type+"s"]:
			if building.type == "object" and _building.type == type:
				total += 1
			elif building.type == "tile":
				var row = _building
				for tile in row:
					if tile == building.tile:
						total += 1
		
		if total > building.max:
			return
	
	#Check if has nessecary materials
	var material_pile = {}
	var materials = building.materials.duplicate()
	var index = -1
	
	for item in inventory:
		if item and material_pile.has(int(item.item)):
			material_pile[int(item.item)] += 1
		elif item:
			material_pile[int(item.item)] = 1
	for _material in materials:
		index += 1
		if material_pile.has(_material):
			material_pile[_material] -= 1
			if material_pile[_material] == 0:
				material_pile.erase(_material)
		else:
			return
	
	#Finally execute in building the building
	index = -1
	for item in inventory:
		index += 1
		if item and materials.has(int(item.item)):
			materials.erase(int(item.item))
			player_container.character.inventory[index] = null
	
	if building.type == "object":
		house_data.inventory[building.type+"s"][type] += 1
	if building.type == "tile":
		house_data.inventory[building.type+"s"][type] += 10
	
	server.CharacterData(player_id, player_container.character)
	server.rpc_id(player_id, "HouseData", house_data, true)

func RequestEntry(username):
	return (
		open_mode == "open"
		or username == player_container.account_data.username
	)

func SaveData():
	var house_data = player_container.account_data.home
	house_data.open_mode = open_mode
	house_data.tiles = tiles
	
	var house_objects_list = player_container.account_data.home.objects
	house_objects_list = []
	for object_id in object_list.keys():
		var object = object_list[object_id]
		
		#Update the accountdata to save it to the database
		if ServerData.buildings.has(object.name):
			house_objects_list.append({
				"type" : object.name,
				"position" : object.position,
			})
			if ServerData.GetBuilding(object.name).catagory == "storage":
				house_objects_list[house_objects_list.size()-1]["loot"] = object.loot
	player_container.account_data.home.objects = house_objects_list
