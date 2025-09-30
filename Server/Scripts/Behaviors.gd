extends Node

func GetClosestPlayer(pos, root):
	var player_list = root.player_list
	var closest = 9999999
	var closest_position
	for player_id in player_list.keys():
		if player_list[player_id]["position"].distance_to(pos) <= closest:
			closest = player_list[player_id]["position"].distance_to(pos)
			closest_position = player_list[player_id]["position"]
	if closest > 16*8:
		return false
	return closest_position

func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector
func DetermineCollisionSafePoint(pos, point, root, enemy_type):
	var space_state = root.get_world_2d().direct_space_state
	var result = true
	var enemy_data = ServerData.GetEnemy(enemy_type)
	var dimensions = Vector2(enemy_data.res, enemy_data.height)
	
	if enemy_data.res == 38:
		dimensions = Vector2(16, 16)
	
	var spots_to_check = [Vector2(0,-dimensions.y/2), Vector2(-dimensions.x/2,0), Vector2(dimensions.x/2,0), Vector2(-dimensions.x/2,-dimensions.y), Vector2(dimensions.x/2,-dimensions.y)]
	for spot in spots_to_check:
		var collisions = space_state.intersect_point(point+root.global_position+spot, 1, [], 1, true, true)
		if collisions.size() > 0:
			for collision in collisions:
				if collision.collider.name == "TileMap":
					result = false
	
	return result

#Stationary
func Stationary(enemy, tick_rate, root):
	return enemy

#Bot NPC
func Bot(enemy, tick_rate, root):
	var last_target = enemy["last_target"] if enemy.has("last_target") else 0
	var target = enemy["target"]
	var pos = enemy["position"]
	var speed = enemy["speed"]
	seed(pos.x + pos.y)
	
	if ((target - pos).length() <= 4 and OS.get_system_time_msecs()-last_target > 1000 * rand_range(1,10)) or OS.get_system_time_msecs()-last_target > 1000*20:
		enemy["last_target"] = OS.get_system_time_msecs()
		randomize()
		var point = pos + Vector2(rand_range(-40,40),rand_range(-40,40))
		if DetermineCollisionSafePoint(pos, point, root, enemy["name"]):
			enemy["target"] = point
	elif (target - pos).length() <= 4:
		return enemy
	
	var x_move = -cos(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	var y_move = -sin(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	var point = enemy["position"] + Vector2(x_move,y_move)
	if DetermineCollisionSafePoint(pos, point, root, enemy["name"]):
		enemy["position"] = point
	return enemy

#Wander around anchor point
func Wander(enemy, tick_rate, root):
	var target = enemy.target
	var pos = enemy.position
	var speed = enemy.speed
	
	var x_move = -cos(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	var y_move = -sin(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	
	enemy["position"] += Vector2(x_move,y_move)
	
	if (target - pos).length() <= 4:
		if (enemy["anchor_position"]-pos).length() >= 20:
			enemy["target"] = enemy["anchor_position"]
		else:
			var point = pos + Vector2(rand_range(-7,7),rand_range(-7,7))
			if DetermineCollisionSafePoint(pos, point, root, enemy["name"]):
				enemy["target"] = point
	return enemy

#Chase after player
func Chase(enemy, tick_rate, root):
	var target = enemy["target"]
	var pos = enemy["position"]
	var speed = enemy["speed"]
	
	var x_move = -cos(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	var y_move = -sin(pos.angle_to_point(target))*(0.1/tick_rate)*(speed/10.0)
	
	enemy["position"] += Vector2(x_move,y_move)
	
	if (target - pos).length() <= 4:
		var closest_position = GetClosestPlayer(pos, root)
		if closest_position:
			var points_to_check = [4,8,12,16]
			var direction = (closest_position - pos).normalized()
			var point = pos
			for factor in points_to_check:
				var temp_point = pos + direction * factor
				if DetermineCollisionSafePoint(pos, temp_point, root, enemy["name"]):
					point = temp_point
				else:
					break
			
			enemy["target"] = point
	return enemy

#Rotate around anchor point, radius is whatever distance away it is on spawn
func Rotate(enemy, tick_rate, root):
	var target = enemy["target"]
	var pos = enemy["position"]
	var speed = enemy["speed"]
	var anchor_pos = enemy["anchor_position"]
	
	var angle = (pos - anchor_pos).angle()
	var radius = (pos - anchor_pos).length()
	var angle_speed = (0.1 / tick_rate) * (speed / 200.0)
	angle += angle_speed
	
	enemy["position"] = anchor_pos + Vector2(cos(angle), sin(angle)) * radius
	
	return enemy
