extends Button

func _on_Settings_pressed():
	GameUI.Popup(GameUI.settings_node.instance())
