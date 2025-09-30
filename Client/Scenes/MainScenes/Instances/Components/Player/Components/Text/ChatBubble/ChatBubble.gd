extends Control

onready var text_node = get_node("PanelContainer/Label")

onready var current_player = GameHandler.player_node
onready var camera = current_player.get_node("Components/Camera2D")
onready var player = get_parent().get_parent()

var timer = 4

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
	
	var final_position = (player.global_position - current_player.global_position) / camera.zoom + Vector2(0, -180) + screen_size / 2
	rect_position = final_position

func _physics_process(delta):
	timer += delta
	if timer > 4: visible = false
	else: visible = true

func Update(text):
	text_node.text = text
	timer = 0
