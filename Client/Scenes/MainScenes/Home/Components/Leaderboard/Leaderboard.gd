extends CanvasLayer

onready var home_node = get_parent()

var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")
var character_scene = load("res://Scenes/MainScenes/Home/Components/Leaderboard/Components/Character.tscn")

onready var character_container = get_node("MarginContainer/ScrollContainer/Top")
onready var leaderboard_nodes = {
	"weekly" : get_node("NavbarContainer/Navbar/Row3/Weekly"),
	"monthly" : get_node("NavbarContainer/Navbar/Row3/Monthly"),
	"all_time" : get_node("NavbarContainer/Navbar/Row3/AllTime")
}

var current_leaderboard = "weekly"
var leaderboards = {
	"weekly" : [],
	"monthly" : [],
	"all_time" : [],
}

func _ready():
	Gateway.Leaderboard(self)

func SwitchLeaderboard(which):
	leaderboard_nodes[current_leaderboard].disabled = false
	leaderboard_nodes[which].disabled = true
	current_leaderboard = which
	
	for child in character_container.get_children():
		character_container.remove_child(child)
	
	var leaderboard = leaderboards[current_leaderboard]
	var index = 0
	for character in leaderboard:
		index += 1
		var character_instance = character_scene.instance()
		character_container.add_child(character_instance)
		character_instance.SetData(character, index)
	
func Return(weekly, monthly, all_time):
	leaderboards.weekly = weekly
	leaderboards.monthly = monthly
	leaderboards.all_time = all_time
	
	leaderboard_nodes["weekly"].disabled = false
	leaderboard_nodes["monthly"].disabled = false
	leaderboard_nodes["all_time"].disabled = false
	
	SwitchLeaderboard("weekly")

func _on_Menu_pressed():
	home_node.Popup(main_menu_node.instance())

func _on_Weekly_pressed():
	SwitchLeaderboard("weekly")

func _on_Monthly_pressed():
	SwitchLeaderboard("monthly")

func _on_AllTime_pressed():
	SwitchLeaderboard("all_time")
