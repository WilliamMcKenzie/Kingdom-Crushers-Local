extends CanvasLayer

onready var home_node = get_parent()

var character_selection_node = load("res://Scenes/MainScenes/Home/Components/CharacterSelection/CharacterSelection.tscn")
var logout_node = load("res://Scenes/MainScenes/Home/Components/Logout/LogoutPopup.tscn")
var leaderboard_node = load("res://Scenes/MainScenes/Home/Components/Leaderboard/Leaderboard.tscn")
var graveyard_node = load("res://Scenes/MainScenes/Home/Components/Graveyard/Graveyard.tscn")

func _ready():
	var monsters = [
		Rect2(Vector2(0, 38*3), Vector2(38,38)),
		Rect2(Vector2(38*2, 0), Vector2(38,38)),
		Rect2(Vector2(38*5, 38), Vector2(38,38)),
		Rect2(Vector2(38*3, 0), Vector2(38,38)),
		Rect2(Vector2(38*5, 38*3), Vector2(38,38)),
		Rect2(Vector2(38*3, 38*2), Vector2(38,38)),
	]
	get_node("Panel/VBoxContainer/Monster").texture.region = monsters[randi() % len(monsters)]

func Return():
	pass

func _on_Play_pressed():
	home_node.Popup(character_selection_node.instance())

func _on_Logout_pressed():
	home_node.Popup(logout_node.instance())

func _on_Discord_pressed():
	OS.shell_open("https://discord.gg/kUfm6xJvbs")

func _on_Wiki_pressed():
	OS.shell_open("https://wiki.kingdomcrushers.io/")

func _on_Leaderboard_pressed():
	home_node.Popup(leaderboard_node.instance())

func _on_Graveyard_pressed():
	home_node.Popup(graveyard_node.instance())
