extends Control

var game_node = preload("res://Scenes/MainScenes/GameUI/Components/Game/Game.tscn")
var player_node = load("res://Scenes/MainScenes/GameUI/Components/Nearby/Components/Player.tscn")

onready var examine_node = get_node("Nearby/Player")
onready var name_node = examine_node.get_node("VBoxContainer/Name")
onready var level_node = examine_node.get_node("VBoxContainer/Level")
onready var character_node = examine_node.get_node("VBoxContainer/CharacterContainer/Character")
onready var players_node = get_node("Nearby/PanelContainer/VBoxContainer/NearbyPlayers")

var previous_players
var player

func Player(data):
	if data == player:
		examine_node.visible = false
		player = null
		return
	
	player = data
	examine_node.visible = true
	name_node.text = data.name
	level_node.text = "Lv. %d %s" % [data.sprite.level, data.sprite.class]
	UtilityFunctions.SetCharacterSprite(data.sprite, character_node)

class SortPlayers:
	static func nearest(a, b):
		var node = GameHandler.player_node.position
		return a.position.distance_to(node) < b.position.distance_to(node)

var timer = 59
func _physics_process(delta):
	timer += 1
	if timer % 60 == 0:
		var players = GameHandler.instance_node.players_node.get_children()
		if previous_players and players and UtilityFunctions.CompareArrays(players, previous_players): return
		else: previous_players = players
		
		for child in players_node.get_children():
			child.queue_free()
		
		players.sort_custom(SortPlayers, "nearest")
		for player in players:
			var player_instance = player_node.instance()
			
			player_instance.nearby_node = self
			players_node.add_child(player_instance)
			player_instance.Player(player.player_data)

func _on_Close_pressed():
	GameUI.Popup(game_node.instance())

func _on_Teleport_pressed():
	Server.Message("/teleport %s" % [player.name])

func _on_Trade_pressed():
	Server.Message("/trade %s" % [player.name])
