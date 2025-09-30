extends Node2D

onready var server = get_node("/root/Server")
onready var tilemap = get_node("TileMap")
var instance
var encounter = false
var room_data = {}

func _ready():
	if room_data.has("start_room") and room_data.has("target_room"):
		HallwaySetup()
	else:
		SpawnEnemies()
		
func SpawnEnemies():
	var tile_translation = instance.tile_translation
	var room_size = instance.room_size
	var enemies = ServerData.enemies
	
	for x in range(-room_size, room_size):
		for y in range(-room_size, room_size):
			var current_tile = tilemap.get_cell(x,y)
			var current_position = position + Vector2(x*8, y*8) - instance.position + Vector2(4,4)
			
			if current_tile in tile_translation:
				if tile_translation[current_tile] in enemies:
					var enemy_name = tile_translation[current_tile]
					if not tile_translation[current_tile] is String:
						enemy_name = tile_translation[randi() % len(tile_translation)]
					instance.SpawnEnemy(enemy_name, current_position-Vector2(4,0))
				else:
					var obstacle_name = tile_translation[current_tile]
					if not tile_translation[current_tile] is String:
						obstacle_name = tile_translation[current_tile][randi() % len(tile_translation[current_tile])]
					CreateObstacle(obstacle_name, current_position, load("res://Scenes/SupportScenes/Obstacles/Small.tscn").instance())
	
func CreateObstacle(obstacle_name, obstacle_position, obstacle):
	var obstacle_id = server.generate_unique_id()
	
	if instance:
		obstacle.name = obstacle_id
		obstacle.position = obstacle_position + instance.position - Vector2(-4,-8)
		
		instance.objects_node.add_child(obstacle)
		instance.object_list[obstacle_id] = {
			"name": obstacle_name,
			"type": "Obstacles",
			"end_time": OS.get_system_time_msecs()+OS.get_system_time_msecs(),
			"position": obstacle_position + instance.position - Vector2(-4,-8)
		}

func HallwaySetup():
	var start_room = get_parent().get_node(str(room_data.start_room))
	var target_room = get_parent().get_node(str(room_data.target_room))
	var direction = room_data.target_room - room_data.start_room
	
	var tiles = []
	var room_size = instance.room_size
	var target_coordinates = direction*Vector2(room_size,room_size)
	
	var tilemap_1 = start_room.get_node("TileMap")
	var tilemap_2 = target_room.get_node("TileMap")
	
	for x in range(-room_size * 2, room_size * 2):
		for y in range(-room_size * 2, room_size * 2):
			if tilemap.get_cell(x,y) > -1:
				tiles.append(Vector2(x, y))
	
	for tile in tiles:
		tilemap_1.set_cell(tile.x, tile.y, -1)
		tilemap_2.set_cell(tile.x-target_coordinates.x ,tile.y-target_coordinates.y, -1)
