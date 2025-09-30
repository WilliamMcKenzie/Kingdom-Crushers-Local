extends "res://Scenes/SupportScenes/PlayerContainer.gd"

var enemy
var target

func _physics_process(delta):
	if not account_data: return
	if not character: return
	
	running_time += delta
	timer += 1
	
	HandleFake()
	ManageHealing()
	if timer >= 60 * 10:
		timer = 0
	if timer % 60 == 0:
		StatBuffs()
		Effects()
		Statistics()
		Quest()

func DecorateFake():
	player_state = Bots.DecorateFake(player_state, character, gear)

func HandleFake():
	FakeMovement()
	FakeAttack()
	
	var closest = OS.get_system_time_msecs()
	var closest_pos = null
	
	if timer % 60 == 0:
		var closest_player = 48*9
		time_between_shots = (1 / (6.5 * (stats.dexterity + 17.3) / 100)) / (ServerData.GetItem(gear.weapon.item).rof / 100.0)
		
		for container in instance.players_node.get_children():
			var distance = container.position.distance_to(position)
			if distance < closest_player and not "target" in container:
				closest_player = distance
		
		if closest_player > 48*8:
			Bots.used_names.erase(account_data.username)
			server._Peer_Disconnected(int(name))
			return
		
		for enemy_id in instance.enemy_list.keys():
			var enemy_data = instance.enemy_list[enemy_id]
			var distance =  enemy_data.position.distance_to(position)
			if distance < closest:
				closest =  distance
				closest_pos = enemy_data.position
		
		if closest < 8:
			target = closest_pos - (position - closest_pos).normalized() * 16
		elif closest < 7*8:
			target = closest_pos
		else:
			target = null
	
	position = enemy.position
	server.RecieveFakePlayerState(int(name), player_state)

func FakeMovement():
	enemy.position = self.position
	enemy.anchor_position = self.position
	enemy = Behaviors.Bot(enemy, 0.1, instance)
	
	player_state.position = enemy.position
	player_state.time = OS.get_system_time_msecs()
	if target:
		player_state.animation = {
			"animation" : "Attack",
			"direction" : self.position.direction_to(target)
		}
	elif self.position != enemy.position:
		player_state.animation = {
			"animation" : "Walk",
			"direction" : self.position.direction_to(enemy.position)
		}
	else:
		player_state.animation.animation = "Idle"

func FakeAttack():
	if target:
		var timing = (OS.get_ticks_msec() / 1000.0) - last_shot_time >= time_between_shots
		var weapon = ServerData.GetItem(gear.weapon.item)
		var distance = self.position.distance_to(target)
		var tile_range = weapon.projectiles[0].tile_range * 8
		
		if distance > tile_range or distance < tile_range - 8:
			enemy.target = target + (self.position - target).normalized() * tile_range
		
		if timing and weapon:
			var i = -1
			
			for data in weapon.projectiles:
				i += 1
				var projectile_data = {
					"name" : data.projectile,
					"direction" : position.direction_to(target),
					"start_position" : position,
					"tile_range" : data.tile_range,
					"piercing" : data.piercing,
					"formula" : data.formula,
					"path" : position,
					"speed" : data.speed,
					"size" : data.size,
					"damage" : ceil(rand_range(10,20)),
					"id" : "",
					
					"index" : i,
					"position" : position,
					"mouse_position": self.position + 100 * Bots.OffsetProjectileAngle(position.direction_to(target), data.offset),
				}
				server.SendFakePlayerProjectile(projectile_data, int(name))
			last_shot_time = OS.get_ticks_msec() / 1000.0
