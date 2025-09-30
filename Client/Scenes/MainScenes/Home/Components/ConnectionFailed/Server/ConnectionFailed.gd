extends CanvasLayer

var home_node

var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")

func _on_Back_pressed():
	home_node.Popup(main_menu_node.instance())
