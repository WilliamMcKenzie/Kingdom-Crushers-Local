extends VBoxContainer

onready var name_node = get_node("Name")

var requester

func Set(who):
	requester = who
	name_node.text = "%s wants to trade" % [who]

func _on_Accept_pressed():
	Server.Send("AcceptTrade", requester)
	GameUI.Popup(GameUI.game_node.instance())

func _on_Reject_pressed():
	GameUI.Popup(GameUI.game_node.instance())
