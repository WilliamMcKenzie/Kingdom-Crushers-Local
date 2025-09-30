extends Control

var home_node = preload("res://Scenes/MainScenes/Home/Home.tscn")

onready var root = get_node("/root/SceneHandler")

func _on_Home_pressed():
	root.SwitchScene(home_node.instance())
