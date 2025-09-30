extends CanvasLayer

onready var home_node = get_parent()

var account_node = load("res://Scenes/MainScenes/Home/Components/Account/AccountPopup.tscn")
var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")

func _ready():
	yield(get_tree().create_timer(5), "timeout")
	home_node.Popup(account_node.instance())

func Return():
	if AccountHandler.data:
		home_node.Popup(main_menu_node.instance())
	else:
		home_node.Popup(account_node.instance())
