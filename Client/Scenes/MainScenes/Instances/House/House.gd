extends "../Map.gd"

onready var tilemap = get_node("TileMap")

func Tiles(tiles):
	var tile_variations = {
		0 : [1,0,0],
		1 : [1,0,0],
		2 : [3,4,0.08],
		3 : [4,2,0.08],
		4 : [1,0,0],
		5 : [1,2,0.05],
		6 : [1,0,0],
	}
	
	for x in range(24):
		for y in range(24):
			var tile = tiles[x][y]
			
			if tilemap.get_cell(x, y) == tile: continue
			
			var num_variations = tile_variations[int(tile)]
			var random_index = 0
			
			#Standard tile
			if num_variations[0] > 1:
				random_index = randi() % num_variations[0]
				
				#Special tile
				if randf() < num_variations[2]:
					random_index = (randi() % num_variations[1]) + num_variations[0]
			
			tilemap.set_cell(x, y, tile, false, false, false, Vector2(random_index, 0))
