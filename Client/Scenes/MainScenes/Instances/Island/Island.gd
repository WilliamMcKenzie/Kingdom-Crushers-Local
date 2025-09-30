extends "../Map.gd"

onready var tile_map_node = get_node("TileMap")

var chunk_size = 16
var loaded_chunks = {}
var map_tiles = {}
var map_objects = []

var chunk_timer = 0
var loading_radius = 24
var tile_variations = {
	0 : [1,0,0],
	1 : [1,0,0],
	2 : [2,3,0.01],
	3 : [3,4,0.08],
	4 : [3,4,0.1],
	5 : [3,6,0.1],
	6 : [2,4,0.25],
	7 : [1,0,0],
	8 : [1,0,0],
	9 : [4,2,0.5],
	10 : [4,2,0.5],
	11 : [2,6,0.3],
}

func _physics_process(delta):
	chunk_timer += 1
	if chunk_timer >= 20:
		chunk_timer = 0
		var player_position = GameHandler.player_node.position
		var base_position = Vector2(round(player_position.x / 8.0), round(player_position.y / 8.0))
		
		for object in map_objects:
			if object.position.distance_to(player_position) < loading_radius * 8:
				var object_instance = load("res://Scenes/MainScenes/Instances/Components/Objects/Obstacles/" + object.name + ".tscn").instance()
				
				object_instance.position = object.position
				object_node.add_child(object_instance)
				map_objects.erase(object)
		
		for x in range(base_position.x - (loading_radius / 2), base_position.x + (loading_radius / 2)):
			for y in range(base_position.y - (loading_radius / 2), base_position.y + (loading_radius / 2)):
				if map_tiles.has(Vector2(x,y)):
					var tile = map_tiles[Vector2(x,y)]
					map_tiles.erase(Vector2(x,y))
					
					var num_variations = tile_variations[tile] if tile_variations.has(tile) else [3,0,0]
					var random_index = 0
					
					if num_variations[0] > 1:
						random_index = randi() % num_variations[0]
						
						if randf() < num_variations[2]:
							random_index = (randi() % num_variations[1]) + num_variations[0]
					
					$TileMap.set_cell(x,y,tile,false,false,false, Vector2(random_index, 0))

func SetSpecialIsland(which):
	var tileset = load("res://Resources/" + which + "_island_tilemap.tres")
	tile_map_node.tile_set = tileset

func GenerateChunk(chunk_data, chunk):
	map_objects += chunk_data.objects
	var tiles = chunk_data.tiles
	
	for x in range(chunk.x-(chunk_size/2), chunk.x+(chunk_size/2)):
		for y in range(chunk.y-(chunk_size/2), chunk.y+(chunk_size/2)):
			var newX = x-chunk.x+(chunk_size/2)
			var newY = y-chunk.y+(chunk_size/2)
			if newX in range(tiles.size()) and newY in range(tiles[newX].size()):
				var tile = tiles[newX][newY]
				map_tiles[Vector2(x,y)] = tile

func LoadChunk(position, offset):
	var player_coords = Vector2(round(position.x / 8), round(position.y / 8))
	var chunk = Vector2(chunk_size * round((player_coords.x + offset.x) / chunk_size), chunk_size * round((player_coords.y + offset.y) / chunk_size))
	
	if chunk in loaded_chunks: return
	
	loaded_chunks[chunk] = true
	Server.Send("FetchChunk", chunk)
