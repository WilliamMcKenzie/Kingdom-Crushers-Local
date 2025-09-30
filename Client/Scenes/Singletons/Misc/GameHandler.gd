extends Node

onready var is_mobile = str(OS.get_model_name()) != 'GenericDevice'
onready var root = get_node("/root/SceneHandler")

var tutorial = -9999
var character_index = 0
var character
var helmet_cooldown = 0
var in_home = false
#len(Server.current_instance_tree) > 1 and Server.current_instance_tree[1] == "house " + str(Server.get_tree().get_network_unique_id())
var is_dead = false
var projectile_patterns = {}

var player_node
var instance_node

var port_node = preload("res://Scenes/MainScenes/Instances/Port/Port.tscn")
var house_node = preload("res://Scenes/MainScenes/Instances/House/House.tscn")
var dungeon_node = preload("res://Scenes/MainScenes/Instances/Dungeon/Dungeon.tscn")
var arena_node = preload("res://Scenes/MainScenes/Instances/Arena/Arena.tscn")
var island_node = preload("res://Scenes/MainScenes/Instances/Island/Island.tscn")
var enemy_projectile = preload("res://Scenes/MainScenes/Instances/Components/Projectiles/Enemies/Projectile.tscn")
var player_projectile = preload("res://Scenes/MainScenes/Instances/Components/Projectiles/Players/Projectile.tscn")
var projectile_pool = preload("res://Scenes/MainScenes/Instances/Components/Projectiles/Pool.tscn")

func _physics_process(delta):
	helmet_cooldown -= delta

func ExitGame():
	GameUI.loot = {}
	GameUI.portals = {}
	root.SetScene(root.home.instance())

func SetHealth(total, new):
	var current = player_node.health
	var delta = new - current
	
	player_node.healthbar_node.Update(new, total)
	player_node.health = new
	
	if delta < 0 and total == player_node.stats.health:
		AudioHandler.Play("hurt")
		player_node.Indicator("damage", delta)

func Death():
	is_dead = true
	AccountHandler.data.characters.remove(character_index)

func NewInstance(data, new_instance):
	Animations.NewInstance(false)
	new_instance.GetPlayer().SetCharacter(instance_node.GetPlayer().character)
	new_instance.GetPlayer().global_position = data.position
	new_instance.name = data.id

	var player_pool = instance_node.get_node_or_null("PlayerProjectiles")
	var enemy_pool = instance_node.get_node_or_null("EnemyProjectiles")
	
	if player_pool:
		instance_node.remove_child(player_pool)
		new_instance.add_child(player_pool)
	if enemy_pool:
		instance_node.remove_child(enemy_pool)
		new_instance.add_child(enemy_pool)
	
	instance_node = new_instance
	player_node = instance_node.GetPlayer()
	
	root.SwitchScene(instance_node)
	
	var cloud_background = (
		"dungeon_name" in new_instance
		and (new_instance.dungeon_name == "cloud_isles" or "babel" in new_instance.dungeon_name)
	)
	
	if cloud_background:
		player_node.CloudBackground()
	else:
		player_node.DefaultBackground()
	
	in_home = (
		"house" in data.id
		and data.id.split(" ")[1] == str(Server.network.get_unique_id())
	)
	if tutorial > 2 and tutorial <= 10:
		tutorial = 10
		GameUI.active_node.EnterKingdom()
	if tutorial == 13:
		GameUI.active_node.EnterHouse()

func Port(spawnpoint):
	Animations.Transition("The Port")
	
	var port_instance = port_node.instance()
	GameHandler.NewInstance({
		"position" : spawnpoint,
		"id" : "port"
	}, port_instance)

func House(data):
	Animations.Transition(data.name + "'s House")
	yield(get_tree().create_timer(0.3), "timeout")
	
	var house_instance = house_node.instance()
	GameHandler.NewInstance(data, house_instance)
	house_instance.Tiles(data.tiles)

remote func Arena(data):
	var arena_instance = arena_node.instance()
	GameHandler.NewInstance(data, arena_instance)
	Animations.NewInstance(true)

remote func Dungeon(data):
	var dungeon_instance = dungeon_node.instance()
	dungeon_instance.PopulateDungeon(data)
	GameHandler.NewInstance(data, dungeon_instance)

remote func Island(data, special):
	var island_instance = island_node.instance()
	if special:
		island_instance.SetSpecialIsland(special)
	GameHandler.NewInstance(data, island_instance)

func WithinRange(vector, radius = 16):
	return player_node.position.distance_to(vector) <= radius * 8

func EnemyProjectile(data, enemy_id):
	if WithinRange(data.position, 64):
		var enemy = instance_node.GetEnemy(enemy_id)
		var pool = instance_node.get_node_or_null("EnemyProjectiles")
		
		if enemy: enemy.ShootProjectile()
		if not pool:
			CreatePool()
			pool = instance_node.get_node_or_null("EnemyProjectiles")
		if pool:
			for projectile in pool.get_children():
				if not projectile.active:
					projectile.Activate(data)
					break

func PlayerProjectile(data, player_id):
	if WithinRange(data.start_position, 64):
		var original = player_id == Server.network.get_unique_id()
		var pool = instance_node.get_node_or_null("PlayerProjectiles")
		
		if not pool:
			CreatePool()
			pool = instance_node.get_node_or_null("PlayerProjectiles")
		if pool:
			for projectile in pool.get_children():
				if not projectile.active:
					projectile.original = original
					projectile.Activate(data)
					break

func RemoveProjectile(id):
	var enemy_pool = instance_node.get_node_or_null("EnemyProjectiles")
	var player_pool = instance_node.get_node_or_null("PlayerProjectiles")
	
	if enemy_pool:
		for projectile in enemy_pool.get_children():
			if projectile.name == str(id):
				return projectile.DeActivate()
	if player_pool:
		for projectile in player_pool.get_children():
			if projectile.name == str(id):
				return projectile.DeActivate()

func CreatePool():
	var enemy_pool = projectile_pool.instance()
	var player_pool = projectile_pool.instance()
	enemy_pool.name = "EnemyProjectiles"
	player_pool.name = "PlayerProjectiles"

	instance_node.add_child(enemy_pool)
	instance_node.add_child(player_pool)
	instance_node.move_child(enemy_pool, 0)
	instance_node.move_child(player_pool, 0)
	
	for i in range(500):
		enemy_pool.add_child(enemy_projectile.instance())
		player_pool.add_child(player_projectile.instance())
	
	return player_pool

func EnterGame():
	character = AccountHandler.data.characters[character_index]
	is_dead = false
	
	Animations.Transition("")
	instance_node = port_node.instance()
	player_node = instance_node.GetPlayer()
	player_node.SetCharacter(character)
	root.SwitchScene(instance_node)
	GameUI.game_node = load("res://Scenes/MainScenes/GameUI/Components/Game/Game.tscn")
	GameUI.Popup(GameUI.game_node.instance())

func UseHelmet():
	Server.UseHelmet()

func Home():
	Server.Message("/home")

func GoPort():
	Server.SendEmpty("Port")

func EnterInstance(dungeon_id, dungeon_name):
	Server.EnterInstance(dungeon_id, dungeon_name)
