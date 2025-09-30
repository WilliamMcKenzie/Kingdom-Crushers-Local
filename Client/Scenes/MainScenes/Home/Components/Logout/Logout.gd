extends CanvasLayer

onready var home_node = get_parent()

var account_node = load("res://Scenes/MainScenes/Home/Components/Account/AccountPopup.tscn")
var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")

func _on_Cancel_pressed():
	home_node.Popup(main_menu_node.instance())

func _on_Continue_pressed():
	AccountHandler.DeleteUser()
	AccountHandler.email = null
	AccountHandler.password = null
	AccountHandler.data = null
	home_node.Popup(account_node.instance())
