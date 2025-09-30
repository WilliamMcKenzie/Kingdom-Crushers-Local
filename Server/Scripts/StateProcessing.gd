extends Node

var sync_clock_counter = 0
var world_state

func _physics_process(delta):
	sync_clock_counter += 1
	if sync_clock_counter == 6:
		sync_clock_counter = 0
		var server = get_node("/root/Server")
		for instance in server.player_instance_tracker.keys():
			if not is_instance_valid(instance):
				server.player_instance_tracker.erase(instance)
				continue
			elif "island" in instance.name:
				SendIslandData(instance)
			else:
				instance.object_list = CleanObjects(instance.object_list).duplicate(true)
				world_state = {
					"players" : instance.player_list,
					"enemies" : instance.enemy_list.duplicate(true),
					"objects" : instance.object_list,
					"time" : OS.get_system_time_msecs()
				}
				
				for enemy_id in world_state.enemies.keys():
					var enemy = world_state.enemies[enemy_id]
					
					if "name" in enemy:
						world_state.enemies[enemy_id] = {
							"name" : enemy.name,
							"position" : enemy.position,
							"target" : enemy.target,
							"speed": enemy.speed,
							"effects" : enemy.effects,
							"dead" : enemy.dead,
							"flip" : enemy.flip,
						}
					else:
						world_state.enemies.erase(enemy_id)
				
				for player_id in server.player_instance_tracker[instance]:
					server.SendWorldState(player_id, world_state)

func SendIslandData(instance):
	instance.object_list = CleanObjects(instance.object_list).duplicate(true)
	var server = get_node("/root/Server")
	var world_state_base = {
		"players" : {},
		"enemies" : {},
		"objects" : {},
		"time" : OS.get_system_time_msecs()
	}
	
	var chunk_size = 16
	var chunk_offsets = [
		Vector2(chunk_size, 0),
		Vector2(chunk_size, chunk_size),
		Vector2(-chunk_size, 0),
		Vector2(-chunk_size, chunk_size),
		Vector2(0, chunk_size),
		Vector2(chunk_size, -chunk_size),
		Vector2(0, -chunk_size),
		Vector2(-chunk_size, -chunk_size)
	]
	
	for chunk in instance.chunks.keys():
		var players = instance.chunks[chunk].players
		if players.keys().size() > 0:
			var world_state = world_state_base.duplicate(true)
			var chunk_data = [instance.GetChunkData(chunk)]
			
			for offset in chunk_offsets:
				chunk_data.append(instance.GetChunkData(chunk + offset))
			
			for chunk_data_value in chunk_data:
				world_state["enemies"].merge(chunk_data_value["enemies"])
				world_state["players"].merge(chunk_data_value["players"])
				world_state["objects"].merge(chunk_data_value["objects"])
			
			for enemy_id in world_state["enemies"]:
				var enemy = world_state["enemies"][enemy_id]
				world_state.enemies[enemy_id] = {
					"name" : enemy.name,
					"position" : enemy.position,
					"target" : enemy.target,
					"speed": enemy.speed,
					"effects" : enemy.effects,
					"dead" : enemy.dead,
					"flip" : enemy.flip,
				}
			
			for id in players:
				server.SendWorldState(id, world_state)

func CleanObjects(objects):
	for objects_id in objects.keys():
		var remove = (
			"end_time" in objects[objects_id]
			and OS.get_system_time_msecs() > objects[objects_id].end_time
		)
		if remove: objects.erase(objects_id)
	return objects
