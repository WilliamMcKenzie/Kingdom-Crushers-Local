extends KinematicBody2D

var main_player = true
var character
var stats
var gear
var health

var projectile_node = preload("res://Scenes/MainScenes/Instances/Components/Projectiles/Players/Projectile.tscn")

var x = 0
var y = 0

var last_animation = {
	"animation" : "Idle",
	"direction" : Vector2.ZERO
}
var last_sprite = {
	"rect" : Rect2(Vector2(0,0), Vector2(80,40)),
	"class" : "Apprentice",
	"gear" : {},
	"level" : 0
}

var shooting = false
var shot_delay = INF
var last_shot = 0
var movement_speed = 0

onready var sprite_container_node = get_node("Control")
onready var sprite_node = get_node("Control/Sprite")
onready var background_1 = get_node("Components/BlackBackground")
onready var background_2 = get_node("Components/SkyBackgound")
onready var camera_node = get_node("Components/Camera2D")
onready var projectiles_placeholder = get_node("Components/ProjectilePlaceholder")
onready var indicators_placeholder = get_node("Components/IndicatorPlaceholder")
onready var effect_nodes = get_node("Text/Nametag/HBoxContainer/Effects").get_children()
onready var chat_bubble = get_node("Components/ChatBubble")
onready var animation_tree = get_node("Components/AnimationTree")
onready var animation_player = get_node("Components/AnimationPlayer")
onready var nametag_node = get_node("Text/Nametag")
onready var chatbubble_node = get_node("Text/ChatBubble")
onready var indicators_node = get_node("Text/Indicators")
onready var healthbar_node = get_node("Text/Healthbar")

func CloudBackground():
	background_2.visible = true
	background_1.visible = false

func DefaultBackground():
	background_2.visible = false
	background_1.visible = true

func HideNametag():
	nametag_node.visible = false

func UnhideNametag():
	nametag_node.visible = true

func _ready():
	SetCharacterSprite()
	Name(GameHandler.character.class, AccountHandler.data.username)
	healthbar_node.Update(stats.health, stats.health)

func Name(classname, username):
	if nametag_node:
		nametag_node.Update(classname, username)

func Message(text):
	chatbubble_node.Update(text)

func SetCharacter(data):
	if data and character and character.hash() == data.hash(): return
	
	if character and character.exp < data.exp:
		#AudioHandler.Play("indicator", 0.1)
		Indicator("exp", data.exp - character.exp)
	if character and character.level < data.level:
		AudioHandler.Play("level_up")
		Indicator("level", data.level - character.level)
	if character and character.ascension_stones < data.ascension_stones:
		#AudioHandler.Play("indicator")
		Indicator("ascension", data.ascension_stones - character.ascension_stones)
	
	character = data.duplicate()
	stats = character.stats.duplicate()
	gear = character.gear
	
	for stat in stats.keys():
		stats[stat] = CompileGear(stat)
	
	if not health or health > stats.health:
		health = stats.health
	
	Name(data.class, AccountHandler.data.username)
	
	if is_inside_tree(): SetCharacterSprite()
	
	if gear.weapon:
		var item = ClientData.GetItem(gear.weapon.item)
		shot_delay = (1 / (6.5 * (stats.dexterity + 17.3) / 100)) / (item.rof / 100.0)
		if "berserk" in character.status_effects:
			shot_delay /= (150.0 / 100.0)
	else:
		shot_delay = INF

func SetCharacterSprite():
	sprite_node.SetCharacterClass(character.class)
	
	if gear.weapon:
		var weapon_data = ClientData.GetItem(gear.weapon.item)
		if weapon_data:
			sprite_node.SetCharacterWeapon(weapon_data.type)
	if last_sprite.class != character.class: UtilityFunctions.SetSpriteData(sprite_node, ClientData.GetCharacter(character.class).path)
	sprite_node.ColorGear(gear, character.class)
	last_sprite = {
		"rect" : sprite_node.get_region_rect(),
		"class" : character.class,
		"gear" : gear,
		"level" : character.level
	}

func _unhandled_input(event):
	if event is InputEventMouseButton and event.device == 0:
		shooting = true

func _physics_process(delta):
	if not GameHandler.is_dead:
		if not GameUI.active_node.name == "Dialogue":
			MovePlayer(delta)
		else:
			Animate("Idle", Vector2.ZERO)
		UpdateSpeed()
		UpdateState()
		UpdateStatusEffects()
		camera_node.zoom = Vector2(0.075 / SettingsHandler.zoom, 0.075 / SettingsHandler.zoom)

func UpdateSpeed():
	var tilemap = GameHandler.instance_node.get_node("TileMap")
	var tile_coords = tilemap.world_to_map(position)
	var tile_index = tilemap.get_cell(tile_coords.x, tile_coords.y)
	
	var unique_tiles = ClientData.unique_tiles
	var tile_data = unique_tiles[tile_index] if tile_index in unique_tiles else null

	if tile_data and tile_data > 0:
		sprite_container_node.rect_size = Vector2(20,7)
		sprite_container_node.rect_position = Vector2(-10,-6)
		movement_speed = stats.speed * tile_data
	elif tile_data == 0:
		sprite_container_node.rect_size = Vector2(20,10)
		sprite_container_node.rect_position = Vector2(-10,-9)
		movement_speed = stats.speed
		
		var motion = Vector2.ZERO
		if(Input.is_action_pressed("up")): motion.y -= 1
		if(Input.is_action_pressed("down")): motion.y += 1
		if(Input.is_action_pressed("left")): motion.x -= 1
		if(Input.is_action_pressed("right")): motion.x += 1
		if GameUI.move_joystick != Vector2.ZERO: motion = GameUI.move_joystick
		
		motion = motion.normalized()
		move_and_slide(motion * -movement_speed)
	else:
		sprite_container_node.rect_size = Vector2(20,10)
		sprite_container_node.rect_position = Vector2(-10,-9)
		movement_speed = stats.speed

func UpdateState():
	var player_state = {
		"time": OS.get_system_time_msecs(),
		"position": get_global_position(),
		"animation": last_animation,
		"sprite": last_sprite
	}
	Server.SendState(player_state)

func UpdateStatusEffects():
	for status_node in effect_nodes:
		if status_node.name in character.status_effects:
			status_node.visible = true
		else:
			status_node.visible = false

func HandleMovement():
	var motion = Vector2.ZERO
	x = 0
	y = 0
	
	if Input.is_action_pressed("up"): y -= 1
	if Input.is_action_pressed("down"): y += 1
	if Input.is_action_pressed("left"): x -= 1
	if Input.is_action_pressed("right"): x += 1
	if GameUI.move_joystick != Vector2.ZERO: motion = GameUI.move_joystick
	
	if Input.is_action_just_released("shoot"):
		shooting = false

	motion.x += x
	motion.y += y
	return motion.normalized()

func HandleAttack(motion):
	var current_time = OS.get_system_time_msecs()
	var shoot_direction = (get_global_mouse_position() - position).normalized()
	var valid_delay = (current_time - last_shot) / 1000.0 >= shot_delay
	var valid_weapon = "weapon" in gear
	
	var pc_shoot = (
		shooting
		and not GameHandler.is_mobile
		and not GameUI.focused
		and GameUI.attack_joystick == Vector2.ZERO
	)
	var mobile_shoot = (
		not GameUI.focused
		and GameUI.attack_joystick != Vector2.ZERO
	)
	
	var walking = motion != Vector2.ZERO
	
	if (pc_shoot or mobile_shoot) and valid_delay and valid_weapon:
		var i = 0
		var id = gear.weapon.item
		var sound = "bow" if id > 165 else "staff" if id > 132 else "sword"
		
		AudioHandler.Play(sound)
		for projectile_data in ClientData.GetItem(gear.weapon.item).projectiles:
			CreateProjectile(projectile_data, i)
			i += 1
		last_shot = current_time
	
	if pc_shoot or mobile_shoot or walking:
		var animation = "Attack" if pc_shoot or mobile_shoot else "Walk"
		var direction = shoot_direction if pc_shoot else GameUI.attack_joystick if mobile_shoot else motion
		Animate(animation, direction)
	else:
		animation_tree.get("parameters/playback").travel("Idle")
		last_animation.animation = "Idle"

func Animate(animation, direction):
	animation_tree.get("parameters/playback").travel(animation)
	animation_tree.set("parameters/Idle/blend_position", direction)
	animation_tree.set("parameters/Walk/blend_position", direction)
	animation_tree.set("parameters/Attack/blend_position", direction)
	last_animation = { "animation" : animation, "direction" : direction }

func MovePlayer(delta):
	if not GameUI.focused:
		var motion = HandleMovement()
		HandleAttack(motion)
		move_and_slide(motion * movement_speed)
		
		var instance = GameHandler.instance_node
		if instance.has_method("LoadChunk"):
			var chunk_size = 16
			instance.LoadChunk(position, Vector2(0, 0))
			instance.LoadChunk(position, Vector2(chunk_size, 0))
			instance.LoadChunk(position, Vector2(chunk_size, chunk_size))
			instance.LoadChunk(position, Vector2(-chunk_size, 0))
			instance.LoadChunk(position, Vector2(-chunk_size, chunk_size))
			instance.LoadChunk(position, Vector2(0, chunk_size))
			instance.LoadChunk(position, Vector2(chunk_size, -chunk_size))
			instance.LoadChunk(position, Vector2(0, -chunk_size))
			instance.LoadChunk(position, Vector2(-chunk_size, -chunk_size))

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction

func CreateProjectile(data, index):
	randomize()
	
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - position).normalized()
	var damage = round(CalculateDamageWithMultiplier((rand_range(data.damage[0], data.damage[1]))))
	var offset
	
	if "offset_variation" in data:
		var variation = rand_range(-data.offset_variation, data.offset_variation)
		offset = ClientData.DegreesToVector(variation)
	else:
		offset = data.offset
	
	if GameUI.attack_joystick != Vector2.ZERO:
		mouse_position = GameUI.attack_joystick * 100 + position
		direction = GameUI.attack_joystick
	else:
		mouse_position = direction * 100 + position
	
	var start_position = projectiles_placeholder.global_position + direction * 3
	var projectile_data = {
		"name" : data.projectile,
		"direction" : OffsetProjectileAngle(direction, offset),
		"start_position" : start_position,
		"tile_range" : data.tile_range,
		"piercing" : data.piercing,
		"formula" : data.formula,
		"path" : start_position,
		"speed" : data.speed,
		"size" : data.size,
		"damage" : damage,
		"id" : "",
		
		"index" : index,
		"position" : projectiles_placeholder.global_position,
		"mouse_position": position + 100 * OffsetProjectileAngle(direction, offset),
	}
	
	Server.Send("SendPlayerProjectile", projectile_data)
	GameHandler.PlayerProjectile(projectile_data, Server.network.get_unique_id())

func CalculateDamageWithMultiplier(damage):
	var base_damage = (damage * (0.5 + (float(stats.attack) / float(100))))
	var multipliers = ClientData.GetMultiplier(gear["weapon"].item)
	
	if multipliers.has("damage"):
		base_damage = floor(base_damage * multipliers.damage)
	if character.status_effects.has("damaging"):
		base_damage = floor(base_damage * 1.25)
	
	return base_damage

func Indicator(which, amount):
	indicators_node.Update(which, amount)

func CompileGear(stat):
	var total = stats[stat]
	for item in gear.values(): if item:
		var data = ClientData.GetItem(item.item, true)
		if stat in data.stats:
			total += data.stats[stat]
	
	return total
