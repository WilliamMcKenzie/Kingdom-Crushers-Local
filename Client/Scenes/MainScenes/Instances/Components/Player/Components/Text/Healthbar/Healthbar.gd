extends Control

onready var health_node = get_node("Health/Healthbar")

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
	
	var final_position = (player.global_position - current_player.global_position) / camera.zoom + Vector2(0, 100) + screen_size / 2
	rect_position = final_position

func _physics_process(delta):
	health_node.value = GameHandler.player_node.health

func Update(health, total):
	#var fg = StyleBoxFlat.new()
	#fg.bg_color = ClientData.GetCharacter(GameHandler.character.class).color
	#fg.corner_radius_bottom_left = 16
	#fg.corner_radius_bottom_right = 16
	#fg.corner_radius_top_left = 16
	#fg.corner_radius_top_right = 16
	
	health_node.value = health
	health_node.max_value = total
	#health_node.add_stylebox_override("fg", fg)
