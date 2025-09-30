extends Node2D

var texture_8x8 = preload("res://Assets/npcs/enemies_8x8.png")
var texture_16x16 = preload("res://Assets/npcs/enemies_16x16.png")
var texture_32x32 = preload("res://Assets/npcs/enemies_32x32.png")

onready var animation_node = get_node("Components/AnimationPlayer")
onready var hitbox_node = get_node("Components/Area2D/Hitbox")
onready var indicators_node = get_node("Text/Indicators")
onready var effects_node = get_node("Components/Effects")
onready var sprite_node = get_node("Control/Sprite")
onready var chat_node = get_node("Text/ChatBubble")
onready var sprite_container = get_node("Control")

var rect_position1 = Vector2(-10,-6)
var rect_position2 = Vector2(-10,-9)
var rect_size1 = Vector2(20,7)
var rect_size2 = Vector2(20,10)
var indicator_offset = Vector2(-80, 0)
var enemy_type = "crab"
var death_stance
var effects = {}
var active

var target = Vector2.ZERO
var last_positions = []
var speed = 0

func _ready(): set_physics_process(false)

func UpdateSprite(enemy_data, texture):
	var height = enemy_data.height
	var scale = enemy_data.scale
	var rect = enemy_data.rect
	var res = enemy_data.res
	
	var rect_variable = (res * scale)
	
	sprite_node.position = Vector2(rect_variable / 2, rect_variable / 2)
	hitbox_node.position = Vector2(0, (height / -2) * scale)
	hitbox_node.disabled = false
	sprite_node.scale = Vector2(scale, scale)
	
	hitbox_node.shape = hitbox_node.shape.duplicate()
	hitbox_node.shape.extents = Vector2((res / 2) * scale, (height / 2) * scale)
	
	sprite_node.material = sprite_node.material.duplicate()
	sprite_node.material.set_shader_param("max_line_width", 0.75 / scale)
	
	if "custom_hitbox" in enemy_data:
		var hitbox = enemy_data.custom_hitbox
		hitbox_node.shape = hitbox_node.shape.duplicate()
		hitbox_node.shape.extents = Vector2(hitbox.x / 2.0, hitbox.y / 2.0)
		hitbox_node.position = Vector2(0, hitbox.y / -2.0)
		if enemy_data.custom_hitbox == Vector2.ZERO:
			hitbox_node.disabled = true
	
	rect_size1 = Vector2(rect_variable, rect_variable-3)
	rect_size2 = Vector2(rect_variable,rect_variable)
	rect_position1 = Vector2(rect_variable / -2, -rect_variable + 3)
	rect_position2 = Vector2(rect_variable / -2, -rect_variable)
	
	indicator_offset = Vector2(0, -(height + 2) * scale * 10)
	effects_node.position = Vector2(0, (height * -scale) + 8)
	
	sprite_node.texture = texture
	sprite_node.region_rect = rect
	sprite_node.hframes = rect.size.x / rect.size.y
	sprite_node.vframes = 1

func UpdateAnimations(animations):
	for animation_name in animation_node.get_animation_list():
		var original_animation = animation_node.get_animation(animation_name)
		var duplicated_animation = original_animation.duplicate(true)
		animation_node.add_animation(animation_name, duplicated_animation)
	
	for animation_name in animations.keys():
		var frame_time = 0
		var animation = animation_node.get_animation(animation_name)
		var key_count = animation.track_get_key_count(0)
		
		for i in range(key_count - 1, -1, -1): animation.track_remove_key(0, i)
		
		animation.length = 0.3 * len(animations[animation_name])
		for frame in animations[animation_name]:
			animation.track_insert_key(0, frame_time, frame)
			frame_time += 0.3

func Activate(enemy_name):
	enemy_type = enemy_name
	indicators_node.visible = true
	chat_node.visible = true
	var enemy_data = ClientData.GetEnemy(enemy_type)
	var animations = enemy_data.animations
	var texture
	
	if enemy_data.res == 10: texture = texture_8x8
	elif enemy_data.res == 18: texture = texture_16x16
	elif enemy_data.res == 38: texture = texture_32x32
	
	UpdateSprite(enemy_data, texture)
	
	UpdateAnimations(animations)
	
	set_physics_process(true)
	UpdateSpeed()
	visible = true
	active = true

func DeActivate():
	GameUI.DeadEnemy(enemy_type)
	hitbox_node.disabled = true
	set_physics_process(false)
	indicators_node.visible = false
	chat_node.visible = false
	visible = false
	active = false
	name = "0"

var timer = 0

func _physics_process(delta):
	timer += 1
	if not get_world_2d() or not get_parent(): return
	
	if speed > 0 and SettingsHandler.smoothing:
		var x_move = -cos(position.angle_to_point(target)) * (speed/60.0)
		var y_move = -sin(position.angle_to_point(target)) * (speed/60.0)
		
		var new_position = position + Vector2(x_move, y_move)
		var can_flip = OS.get_system_time_msecs() - last_flip > 100
		var direction = new_position.x - position.x < 0
		
		if can_flip:
			last_flip = OS.get_system_time_msecs()
			sprite_node.flip_h = direction
		position = new_position
	
	if timer % 10:
		if death_stance: hitbox_node.disabled = true
		else: hitbox_node.disabled = false
		
		if death_stance: animation_node.play("Death")
		if not animation_node.is_playing(): animation_node.play("Idle")
	
	if timer == 20:
		timer = 0
		UpdateSpeed()
		UpdateEffects(effects)

func UpdateEffects(status_effects):
	for status_node in effects_node.get_node("HBoxContainer").get_children():
		status_node.visible = status_node.name in status_effects

func UpdateSpeed():
	var tilemap = GameHandler.instance_node.get_node("TileMap")
	var tile_coords = tilemap.world_to_map(position)
	var tile_index = tilemap.get_cell(tile_coords.x, tile_coords.y)
	
	var unique_tiles = ClientData.unique_tiles
	var tile_data = unique_tiles[tile_index] if tile_index in unique_tiles else null
	var valid_enemy = not "no_sink" in ClientData.GetEnemy(enemy_type)

	if valid_enemy and tile_data:
		sprite_container.rect_size = rect_size1
		sprite_container.rect_position = rect_position1
	else:
		sprite_container.rect_size = rect_size2
		sprite_container.rect_position = rect_position2

var theoretical_position = position
var last_flip = 0

func MoveEnemy(new_position, _target, _speed, flip = -1):
	if not SettingsHandler.smoothing:
		position = new_position
		if flip != -1:
			sprite_node.flip_h = flip == 1
			return
	
	target = _target
	speed = _speed
	
	if len(last_positions) > 6 and last_positions[0] == new_position:
		last_positions.pop_back()
		speed = 0
	if GameHandler.WithinRange(new_position):
		if flip != -1:
			sprite_node.flip_h = flip == 1
			return
		
		if position.distance_to(new_position) > 8:
			position = new_position
		visible = true
	else:
		visible = false
	
	last_positions.append(new_position)
	if len(last_positions) > 7:
		last_positions = []

func ShootProjectile():
	animation_node.play("Attack")

#Damage Taken section
func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector

func Indicator(which, amount):
	indicators_node.Update(which, amount, indicator_offset)

func _on_Area2D_area_entered(area):
	var projectile = area.get_parent()
	var is_projectile = "damage" in projectile
	var damage = projectile.damage if is_projectile and not "invincible" in effects else 0
	
	if is_projectile and projectile.original and projectile.active:
		Server.DamageEnemy(name, damage)
	if is_projectile and projectile.active:
		AudioHandler.Play("explosion")
		Indicator("damage", -1 * damage)
		if not projectile.piercing: projectile.DeActivate()
