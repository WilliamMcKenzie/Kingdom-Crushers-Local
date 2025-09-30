extends Container

var texture_8x8 = preload("res://Assets/npcs/enemies_8x8.png")
var texture_16x16 = preload("res://Assets/npcs/enemies_16x16.png")
var texture_32x32 = preload("res://Assets/npcs/enemies_32x32.png")

onready var compass_node = get_node("Compass")
onready var background_node = get_node("Background")
onready var enemy_node = get_node("MarginContainer/TextureRect")
onready var ship_node = get_node("MarginContainer/ShipContainer")
onready var player_node = GameHandler.player_node

var target = 0

func _ready():
	modulate = Color(1,1,1,0)

func _process(delta):
	var rotation = background_node.rect_rotation
	var change = (target - ((rotation + target) / 2)) / 10
	background_node.rect_rotation += change

func Quest(quest):
	modulate = Color(1,1,1,1)
	background_node.visible = (not not quest) or GameHandler.instance_node.name == "port"
	enemy_node.visible = not not quest
	player_node = GameHandler.player_node
	ship_node.visible = GameHandler.instance_node.name == "port"
	
	if GameHandler.instance_node.name == "port":
		quest = {
			"position" : Vector2(0, -74)
		}
	elif quest:
		var data = ClientData.GetEnemy(quest.name)
		var texture = (
			texture_8x8 if data.res == 10
			else texture_16x16 if data.res == 18
			else texture_32x32
		)
		UpdateSprite(data, texture)
	elif not quest or not is_instance_valid(player_node):
		return
	
	var player_position = player_node.position
	var position = quest.position
	var result = player_position.direction_to(position)
	
	compass_node.global_position = player_position
	compass_node.look_at(position)
	target = 90 + compass_node.rotation_degrees

func UpdateSprite(data, texture):
	var height = data.height
	var scale = data.scale
	var rect = data.rect
	var res = data.res
	
	enemy_node.material = enemy_node.material.duplicate()
	enemy_node.material.set_shader_param("max_line_width", 0.75 / scale)
	
	enemy_node.texture.atlas = texture
	enemy_node.texture.region = Rect2(rect.position, Vector2(rect.size.y, rect.size.y))
