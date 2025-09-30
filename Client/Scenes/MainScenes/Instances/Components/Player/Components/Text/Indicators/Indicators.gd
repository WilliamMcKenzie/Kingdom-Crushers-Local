extends Control

var indicator_node = load("res://Scenes/MainScenes/Instances/Components/Player/Components/Text/Indicators/Indicator.tscn")

onready var current_player = GameHandler.player_node
onready var camera = current_player.get_node("Components/Camera2D")
onready var player = get_parent().get_parent()
var offset = Vector2(0, -80)

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
	
	var final_position = (player.global_position - current_player.global_position) / camera.zoom + offset + screen_size / 2
	rect_position = final_position

func Update(which, amount, _offset = offset):
	var indicator = indicator_node.instance()
	var display_sign = "+" if amount > 0 else "-" if  amount < 0 else ""
	var addon = (
		" EXP" if which == "exp"
		else " LV" if which == "level"
		else " GOLD" if which == "gold" else ""
	)
	
	offset = _offset
	indicator.Set(which)
	indicator.text = display_sign + str(abs(amount)) + addon
	add_child(indicator)
