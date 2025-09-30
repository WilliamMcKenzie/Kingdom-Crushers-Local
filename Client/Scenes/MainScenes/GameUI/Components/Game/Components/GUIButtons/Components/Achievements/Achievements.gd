extends Button

func _on_Achievements_pressed():
	GameUI.Popup(GameUI.achievements_node.instance())
