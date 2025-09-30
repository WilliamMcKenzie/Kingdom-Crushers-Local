extends Button

func _on_Nearby_pressed():
	var nearby_instance = GameUI.nearby_node.instance()
	GameUI.Popup(nearby_instance)
