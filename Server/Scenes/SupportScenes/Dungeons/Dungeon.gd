extends "res://Scenes/Main/Map.gd"

#Room size accounts for hallways in between
var dungeon_boss = "mummified_king"
var dungeon_name = "poop"
var room_size = 20
var map = {}
var tile_translation = {}

var timer = 1

func GetMapSpawnpoint():
	if ServerData.dungeons[dungeon_name].has("spawnpoint"):
		return ServerData.dungeons[dungeon_name].spawnpoint
	return Vector2(room_size/2*8, room_size/2*8)

func _ready():
	if map != {}:
		PopulateDungeon()

func _physics_process(delta):
	timer += 1
	if timer ==  60:
		timer = 0
		
		var is_empty = players_node.get_child_count() == 0 and get_child_count() == 2
		var is_open = get_parent().object_list.has(name)
		
		if is_empty and not is_open:
			queue_free()

#For creating new dungeon instances
func PopulateDungeon():
	var id = name
	
	#We add the hallways after so they go on top of the room tiles
	var hallways_to_add = []
	
	var room_nodes = {}
	var hallway_nodes = {
		Vector2(1,0) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayRight.tscn"),
		Vector2(0,1) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayDown.tscn"),
		Vector2(-1,0) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayLeft.tscn"),
		Vector2(0,-1) : load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/Hallways/HallwayUp.tscn"),
	} 
	
	for room in map.keys():
		room_nodes[room] = load("res://Scenes/SupportScenes/Dungeons/"+dungeon_name+"/"+map[room].room_type+".tscn")
	
	#Set initial hallways in spawn room
	var coordinate_map = {
		0 : Vector2(1,0),
		1 : Vector2(0,1),
		2 : Vector2(-1,0),
		3 : Vector2(0,-1),
	}
	for _coordinate in range(4):
		if not map.has(coordinate_map[_coordinate]):
			continue
		
		var coordinate = coordinate_map[_coordinate]
		var room_data = map[coordinate]
		
		if room_data.root_path == coordinate:
			var hallway_to_add = hallway_nodes[coordinate].instance()
			hallway_to_add.room_data["start_room"] = Vector2.ZERO
			hallway_to_add.room_data["target_room"] = coordinate
			hallways_to_add.append(hallway_to_add)
	
	for room in map.keys():
		var room_to_add = room_nodes[room].instance()
		var room_data = map[room]
		
		room_to_add.position = room*(room_size)*8
		room_to_add.instance = self
		room_to_add.name = str(room)
		$YSort.add_child(room_to_add)
		
		if room_data.has("direction"):
			var hallway_to_add = hallway_nodes[room_data.direction].instance()
			
			hallway_to_add.room_data["start_room"] = room
			hallway_to_add.room_data["target_room"] = room+room_data.direction
			hallway_to_add.position = room*(room_size)*8
			hallways_to_add.append(hallway_to_add)
	
	for hallway in hallways_to_add:
		hallway.instance = self
		$YSort.add_child(hallway)
