extends Node2D

var player_data

onready var sprite_container_node = get_node("Control")
onready var sprite_node = get_node("Control/Sprite")
onready var projectiles_placeholder = get_node("Components/ProjectilePlaceholder")
onready var indicators_placeholder = get_node("Components/IndicatorPlaceholder")
onready var effect_nodes = get_node("Text/Nametag/HBoxContainer/Effects").get_children()
onready var chat_bubble = get_node("Components/ChatBubble")
onready var animation_tree = get_node("Components/AnimationTree")
onready var animation_player = get_node("Components/AnimationPlayer")
onready var text_node = get_node("Text")
onready var nametag_node = get_node("Text/Nametag")
onready var chatbubble_node = get_node("Text/ChatBubble")

var last_class

func _physics_process(delta):
	visible = not SettingsHandler.hide_players
	text_node.visible = not SettingsHandler.hide_players
	if SettingsHandler.hide_players:
		return
	UpdateSpeed()

func _ready():
	Name(player_data.sprite.class, player_data.name)

func Name(classname, username):
	player_data.name = username
	nametag_node.Update(classname, username)

func Message(text):
	chatbubble_node.Update(text)

func UpdateSpeed():
	var tilemap = GameHandler.instance_node.get_node("TileMap")
	var tile_coords = tilemap.world_to_map(position)
	var tile_index = tilemap.get_cell(tile_coords.x, tile_coords.y)
	
	var unique_tiles = ClientData.unique_tiles
	var tile_data = unique_tiles[tile_index] if tile_index in unique_tiles else null
	
	if tile_data and tile_data > 0:
		sprite_container_node.rect_size = Vector2(20,7)
		sprite_container_node.rect_position = Vector2(-10,-6)
	elif tile_data == 0:
		sprite_container_node.rect_size = Vector2(20,10)
		sprite_container_node.rect_position = Vector2(-10,-9)
	else:
		sprite_container_node.rect_size = Vector2(20,10)
		sprite_container_node.rect_position = Vector2(-10,-9)


func SetCharacterSprite(sprite):
	player_data.sprite = sprite
	
	var path = ClientData.GetCharacter(sprite.class).path
	sprite_node.SetCharacterClass(sprite.class)
	sprite_node.ColorGear(sprite.gear, sprite.class)
	sprite_node.region_rect = sprite.rect
	
	if last_class == sprite.class: UtilityFunctions.SetSpriteData(sprite_node, path)

func UpdateStatusEffects(status_effects):
	for status_node in effect_nodes:
		if status_effects.has(status_node.name): status_node.visible = true
		else: status_node.visible = false

func MovePlayer(new_position, data):
	var animation = data.animation
	var sprite = data.sprite
	var username = data.name
	
	position = new_position
	SetCharacterSprite(sprite)
	Name(sprite.class, username)
	
	var valid_animation = (
		animation is Dictionary
		and "animation" in animation
		and "direction" in animation
	)
	
	if valid_animation:
		var type = animation.animation
		var direction = animation.direction
		
		animation_tree.get("parameters/playback").travel(type)
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
		animation_tree.set("parameters/Attack/blend_position", direction)
