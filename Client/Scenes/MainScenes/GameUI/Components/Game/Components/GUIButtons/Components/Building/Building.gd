extends Button

func _physics_process(delta):
	visible = GameHandler.in_home

func _on_Building_pressed():
	GameUI.Popup(GameUI.build_node.instance())
