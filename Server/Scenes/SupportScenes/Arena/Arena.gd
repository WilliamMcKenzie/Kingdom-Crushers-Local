extends "res://Scenes/Main/Map.gd"

#Room size accounts for hallways in between
var player_id
var player_container
var arena_type = "daily"
var boss_spawnpoints = []
var enemy_spawnpoints = [
	CreateSpawnpoint(0,8),
	CreateSpawnpoint(8,0),
	CreateSpawnpoint(0,-8),
	CreateSpawnpoint(-8,0),
	CreateSpawnpoint(7,-7),
	CreateSpawnpoint(7,7),
	CreateSpawnpoint(-7,7),
	CreateSpawnpoint(-7,-7),
]

var wave_countdown = 3
var wave = 0
var waves = {
	"daily" : [
		{
			"monsters" : ["crab","crab","crab","crab","slime","slime","slime","slime"],
			"bosses" : ["goblin_cannon"],
			"gold" : 5,
		},
		{
			"monsters" : ["cyclops_underling","cyclops_underling","cyclops_underling","cyclops_underling"],
			"bosses" : ["cyclops_leader"],
			"gold" : 5,
		},
		{
			"monsters" : ["nature_druid","ice_druid","fire_druid","shadow_druid"],
			"bosses" : [],
			"gold" : 5,
		},
		{
			"monsters" : ["rat_mage","rat_mage","rat_mage","rat_mage","rat_warrior","rat_warrior","rat_warrior","rat_warrior"],
			"bosses" : ["rat_king"],
			"gold" : 5,
		},
		{
			"monsters" : ["shadow_druid","skeletal_archer","shadow_druid","skeletal_archer"],
			"bosses" : ["cacodemon"],
			"gold" : 5,
		},
		{
			"monsters" : ["ice_troll","ice_troll","ice_troll","ice_troll","frozen_monolith","frozen_monolith","frozen_monolith","frozen_monolith"],
			"bosses" : ["ice_demon"],
			"gold" : 10,
		},
		{
			"monsters" : ["demonic_fledgling","demonic_fledgling","demonic_fledgling","demonic_fledgling", "phoenix","phoenix","phoenix","phoenix"],
			"bosses" : ["demonic_beast"],
			"gold" : 10,
		},
		{
			"monsters" : ["sand_golem","sand_golem","sand_golem","sand_golem","basalisk","basalisk","basalisk","basalisk"],
			"bosses" : [],
			"gold" : 10,
		},
		{
			"monsters" : ["ice_demon","ice_demon","cacodemon","cacodemon","demonic_fledgling","demonic_fledgling","demonic_fledgling","demonic_fledgling"],
			"bosses" : ["vajira", "oranix", "raa'sloth"],
			"gold" : 10,
		},
	],
	"monthly" : [
		{
			"monsters" : ["imp_archer","imp_archer","imp_archer","imp_archer"],
			"bosses" : ["cyclops_leader"],
			"gold" : 20,
		},
		{
			"monsters" : ["viking_warrior","rat_warrior","skeletal_warrior","rat_warrior","rat_warrior","skeletal_warrior"],
			"bosses" : ["rat_king"],
			"gold" : 20,
		},
		{
			"monsters" : ["phoenix","fire_druid","phoenix","fire_druid","phoenix","phoenix"],
			"bosses" : ["fire_druid"],
			"gold" : 20,
		},
		{
			"monsters" : ["lil_rock_golem","ice_golem","sand_golem","sand_golem","ice_golem"],
			"bosses" : ["rokk_the_rough"],
			"gold" : 20,
		},
		{
			"monsters" : ["vigil_construct","cacodemon","vigil_construct","cacodemon","vigil_construct"],
			"bosses" : ["mummified_king"],
			"gold" : 20,
		},
		{
			"monsters" : ["ice_golem","ice_golem","ice_demon","ice_demon","frozen_monolith","frozen_monolith","frozen_monolith"],
			"bosses" : ["vajira"],
			"gold" : 20,
		},
		{
			"monsters" : ["demonic_beast","demonic_fledgling","demonic_fledgling","demonic_beast","demonic_fledgling"],
			"bosses" : ["raa'sloth","eye_of_naa'zorak"],
			"gold" : 30,
		},
		{
			"monsters" : ["basalisk","basalisk","basalisk","vigil_guardian","vigil_guardian"],
			"bosses" : ["atlas"],
			"gold" : 30,
		},
		{
			"monsters" : ["vajira","ice_demon","ice_demon","raa'sloth","oranix"],
			"bosses" : ["og_the_treacherous"],
			"gold" : 50,
		},
	]
}

func CreateSpawnpoint(x,y):
	return (Vector2(x*8, y*8) + Vector2(4,4))

func _ready():
	var tilemap = get_node("TileMap")
	arena = true
	
	for i in range(len(enemy_spawnpoints)):
		enemy_spawnpoints[i] -= position
	for x in range(-100, 100):
		for y in range(-100, 100):
			var current_tile = tilemap.get_cell(x,y)
			var current_position =  Vector2(x*8, y*8) + Vector2(4,4) - position
			
			if current_tile == 7:
				enemy_spawnpoints.append(current_position)
			if current_tile == 8:
				boss_spawnpoints.append(current_position)
	server.rpc_id(player_id, "Wave", wave)

func _physics_process(delta):
	var is_empty = players_node.get_child_count() == 0 and get_child_count() == 2
	if is_empty:
		server.player_instance_tracker.erase(self)
		queue_free()
	
	if len(enemy_list) == 0:
		wave_countdown -= delta
	
	var data = waves[arena_type][wave - 1]
	if wave_countdown < 0 and len(waves[arena_type]) == wave:
		var gold = data.gold
		player_container.GiveGold(gold)
		
		if players_node.get_child_count() > 0:
			if arena_type == "monthly":
				players_node.get_children()[0].GiveItem(3, 1)
				
				if rand_range(0, 10) >= 9:
					players_node.get_children()[0].GiveItem(499, 1)
			
			players_node.get_children()[0].DealDamage(9999, "Gladius")
	elif wave_countdown < 0:
		wave_countdown = 2
		
		if wave - 1 >= 0:
			var gold = data.gold
			player_container.GiveGold(gold)
			server.rpc_id(player_id, "Wave", wave)
		
		randomize()
		var bosses = waves[arena_type][wave].bosses
		var monsters = waves[arena_type][wave].monsters
		var unused_spawnpoints = enemy_spawnpoints.duplicate()
		wave += 1
		for monster in monsters:
			if len(unused_spawnpoints) == 0:
				break
			var spawnpoint = unused_spawnpoints[0]
			unused_spawnpoints.erase(spawnpoint)
			SpawnEnemy(monster, spawnpoint)
		
		if len(bosses) > 0:
			SpawnEnemy(bosses[randi() % len(bosses)], boss_spawnpoints[randi() % len(boss_spawnpoints)])
