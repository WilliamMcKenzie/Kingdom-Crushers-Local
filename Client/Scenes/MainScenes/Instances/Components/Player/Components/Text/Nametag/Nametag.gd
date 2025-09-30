extends Control

onready var name_node = get_node("HBoxContainer/HBoxContainer/Label")
onready var icon_node = get_node("HBoxContainer/HBoxContainer/TextureRect")

onready var current_player = GameHandler.player_node
onready var camera = current_player.get_node("Components/Camera2D")
onready var player = get_parent().get_parent()

func _process(delta):
	var screen_size = OS.window_size
	var base_screen_size = Vector2(1920, 1080)
	
	var screen_ratio = screen_size.x / screen_size.y
	var base_screen_ratio = base_screen_size.x / base_screen_size.y
	
	if screen_ratio > base_screen_ratio:
		screen_size.x = (screen_size.x / screen_size.y) * base_screen_size.y
		screen_size.y = base_screen_size.y
	else:
		screen_size.y = (screen_size.y / screen_size.x) * base_screen_size.x
		screen_size.x = base_screen_size.x
	
	var final_position = (player.global_position - current_player.global_position) / camera.zoom + Vector2(10, -90) + screen_size / 2
	rect_position = final_position

func Update(classname, username):
	var icon_coords = ClientData.GetCharacter(classname).icon
	var color = ClientData.GetCharacter(classname).color
	
	icon_node.texture = icon_node.texture.duplicate()
	icon_node.texture.region = Rect2(icon_coords, Vector2(10, 10))
	name_node.add_color_override("font_color", color)
	name_node.text = username
