extends Control

var category_node = preload("res://Scenes/MainScenes/GameUI/Components/Achievements/Components/Category.tscn")
var achievement_node = preload("res://Scenes/MainScenes/GameUI/Components/Achievements/Components/Achievement.tscn")

onready var categories_node = get_node("HBoxContainer/Categories")
onready var achievements_node = get_node("HBoxContainer/VBoxContainer/ScrollContainer/Achievements")

func _ready():
	var account_data = AccountHandler.data
	var categories = ClientData.achievement_catagories
	
	for catagory in categories.keys():
		var instance = category_node.instance()
		instance.Set(catagory)
		instance.root = self
		instance.name = catagory
		categories_node.add_child(instance)
	
	SetCategory(categories.keys()[0])

func SetCategory(which):
	var achievements = ClientData.achievement_catagories[which].achievements
	
	for node in categories_node.get_children():
		if node is Button:
			node.disabled = false
	categories_node.get_node(which).disabled = true
	
	for node in achievements_node.get_children():
		node.queue_free()
	
	for achievement in achievements:
		var instance = achievement_node.instance()
		var completed = (
			achievement in AccountHandler.data.achievements
			and AccountHandler.data.achievements[achievement]
		)
		
		achievements_node.add_child(instance)
		instance.name = achievement
		instance.Set(achievement)
		if completed:
			instance.Completed()

func _on_Close_pressed():
	GameUI.Popup(GameUI.game_node.instance())
