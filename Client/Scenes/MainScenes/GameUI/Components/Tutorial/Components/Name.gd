extends Control

onready var username_node = get_node("Panel/VBoxContainer/Username")
onready var error_node = get_node("Panel/VBoxContainer/Error")

func Return(result):
	print(result)
	if result == 1:
		GameUI.Popup(GameUI.game_node.instance())
	if result == 0: error_node.text = "Username taken"
	else: error_node.text = "Invalid username"

func _on_Continue_pressed():
	Server.Send("ChooseUsername", username_node.text)

func _on_Username_focus_entered():
	GameUI.focused = true

func _on_Username_focus_exited():
	GameUI.focused = false
