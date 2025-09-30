extends "res://Scenes/SupportScenes/Island/Island.gd"

var which = "halloween"
var special_data = {
	"halloween" : {
		"player_spawnpoint_tile_id" : 12,
		"ruler" : "pumpkin_tyrant",
		"enemies" : {
			"beach_enemies" : [],
			"forest_enemies" : [],
			"plains_enemies" : [],
			"badlands_enemies" : [],
			"mountain_enemies" : ["shadow_spider","greater_slime","ghastly_ghoul"],
		}
	},
	"tundra" : {
		"player_spawnpoint_tile_id" : 2,
		"ruler" : "oracle",
		"enemies" : {
		}
	},
}

var tile_values = {
	"halloween" : {
		0 : [2, 0, 0],
		1 : [1.3, 0, 1],
		12 : [0.75, 1/5, 2],
		6 : [0.7, 1/5, 3]
	},
	"tundra" : {
		0 : [2, 0, 0],
		1 : [1.5, 0, 1],
		2 : [1.25, 1/5, 2],
		3 : [1.2, 1/5, 3],
		4 : [1, 1/5, 4],
		5 : [0.8, 1/5, 5],
		6 : [0.5, 1/5, 6],
		12 : [0.3, 1/5, 7],
	}
}

func PopulateTiles():
	var center = map_size / 2
	var length = center.length()
	
	#For wavy edges of island
	var noise_scale = 0.6
	var noise_intensity = 0.05
	
	for x in range(map_size.x):
		map_as_array.append([])
		for y in range(map_size.y):
			map_as_array[x].append(0)
			var distance = (Vector2(x, y) - center).length()
			var noise_value = noise.get_noise_2d(x * noise_scale, y * noise_scale) * noise_intensity
			
			var highest = -1
			for tile in tile_values[which].keys():
				var data = tile_values[which][tile]
				var value = (1.0 - (distance / (length*data[0])))
				if value > tile_cap and tile > highest:
					highest = data[2]
					map_as_array[x][y] = tile

func SpecialInit():
	var data = special_data[which]
	ruler = data.ruler
	player_spawnpoint_tile_id = data.player_spawnpoint_tile_id
	
	var enemies = data.enemies
	if enemies.has("beach_enemies"):
		beach_enemies = enemies.beach_enemies
	if enemies.has("forest_enemies"):
		forest_enemies = enemies.forest_enemies
	if enemies.has("plains_enemies"):
		plains_enemies = enemies.plains_enemies
	if enemies.has("badlands_enemies"):
		badlands_enemies = enemies.badlands_enemies
	if enemies.has("mountain_enemies"):
		mountain_enemies = enemies.mountain_enemies
