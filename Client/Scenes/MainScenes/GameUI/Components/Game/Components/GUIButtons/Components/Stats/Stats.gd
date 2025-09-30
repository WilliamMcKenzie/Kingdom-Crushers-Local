extends Button

func _on_Stats_pressed():
	var stats_instance = GameUI.stats_node.instance()
	GameUI.Popup(stats_instance)
