extends "../Map.gd"

#Room size accounts for hallways in between
onready var tilemap_node = get_node("TileMap")
var room_size
var dungeon_name
var map_tiles = {}

#For creating new dungeon instances
var timer_2 = 0
func _physics_process(delta):
	timer_2 += 1
	
	if timer_2 >= 20:
		timer_2 = 0
		
		var player = GameHandler.player_node
		
		var base_position = Vector2(round(player.position.x/8.0), round(player.position.y/8.0))
		var loading_radius = 12
		
		for x in range(base_position.x - loading_radius, base_position.x + loading_radius):
			for y in range(base_position.y - loading_radius, base_position.y + loading_radius):
				if map_tiles.has(Vector2(x,y)):
					var tile = map_tiles[Vector2(x,y)][0]
					var autotile_coord = map_tiles[Vector2(x,y)][1]
					map_tiles.erase(Vector2(x,y))
					tilemap_node.set_cell(x,y,tile, false, false, false, autotile_coord)

func PopulateDungeon(instance_data):
	dungeon_name = instance_data.name
	room_size = instance_data.room_size
	var map = instance_data.map
	var id = instance_data.id
	
	#We add the hallways after so they go on top of the room tiles
	var hallways_to_add = []
	
	var room_nodes = {}
	var hallway_nodes = {
		Vector2(1,0) : load("res://Scenes/MainScenes/Instances/Dungeons/"+dungeon_name+"/Hallways/HallwayRight.tscn"),
		Vector2(0,1) : load("res://Scenes/MainScenes/Instances/Dungeons/"+dungeon_name+"/Hallways/HallwayDown.tscn"),
		Vector2(-1,0) : load("res://Scenes/MainScenes/Instances/Dungeons/"+dungeon_name+"/Hallways/HallwayLeft.tscn"),
		Vector2(0,-1) : load("res://Scenes/MainScenes/Instances/Dungeons/"+dungeon_name+"/Hallways/HallwayUp.tscn"),
	} 
	
	for room in map.keys():
		room_nodes[room] = load("res://Scenes/MainScenes/Instances/Dungeons/"+dungeon_name+"/"+map[room].room_type+".tscn")
	
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
		room_to_add.name = str(room)
		add_child(room_to_add)
		
		if room_data.has("direction"):
			var hallway_to_add = hallway_nodes[room_data.direction].instance()
			
			hallway_to_add.room_data["start_room"] = room
			hallway_to_add.room_data["target_room"] = room+room_data.direction
			hallway_to_add.position = room*(room_size)*8
			hallway_to_add.name = str(room)
			hallways_to_add.append(hallway_to_add)
	
	for hallway in hallways_to_add:
		add_child(hallway)
