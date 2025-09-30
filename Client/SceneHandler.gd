extends Node

onready var current = get_node("Home")

func SwitchScene(node):
	GameUI.visible = not "home" in node
	
	current.queue_free()
	current = node
	add_child(current)
