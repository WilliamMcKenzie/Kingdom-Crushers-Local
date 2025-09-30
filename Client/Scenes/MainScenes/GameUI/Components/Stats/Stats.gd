extends Control

var stat_node = preload("res://Scenes/MainScenes/GameUI/Components/Stats/Components/Stat.tscn")

onready var stats_node = get_node("StatsContainer/PanelContainer/VBoxContainer/Stats")
onready var sprite_node = get_node("StatsContainer/PanelContainer/VBoxContainer/CharacterContainer/Character")
onready var info_node = get_node("StatsContainer/PanelContainer/VBoxContainer/Info")
onready var gems_node = get_node("StatsContainer/PanelContainer/VBoxContainer/HBoxContainer/Gems")

func _ready():
	Character(GameHandler.character)

func Character(character):
	info_node.text = "Lv. %d %s" % [character.level, character.class]
	SetStats(character)
	Gems(character.ascension_stones - character.used_ascension_stones)
	UtilityFunctions.SetCharacterSprite(character, sprite_node)

func Gems(gems):
	gems_node.visible = gems > 0
	gems_node.get_node("Label").text = str(gems)
	
	for stat in stats_node.get_children():
		stat.increase_node.visible = gems > 0

func GetPotential(classname):
	var level = min(GameHandler.character.level, 10)
	var ascension_stones = ClientData.GetCharacter(classname).ascension_stones
	var stats = ["health", "attack", "defense", "speed", "dexterity", "vitality"]
	var potential = {
		"health" : 100 + 40 * level,
		"attack" : 20 + 2 * level,
		"defense" : 0,
		"speed" : 20 + 1 * level,
		"dexterity" : 20 + 2 * level,
		"vitality" : 20 + 2 * level,
	}
	
	var key = ClientData.class_map[classname].duplicate()
	for i in range(len(key)):
		var new_character = ClientData.class_map_inversed[key]
		var new_character_stats = ClientData.GetCharacter(new_character).bonus_stats
		for stat in stats:
			potential[stat] += new_character_stats[stat]
		key.pop_back()
	
	for stat in stats:
		potential[stat] += ascension_stones * (5 if stat == "health" else 1)
	
	return potential

func SetStats(character):
	var gear = character.gear
	var potential = GetPotential(character.class)
	var bonus = {
		"health" : 0,
		"attack" : 0,
		"defense" : 0,
		"speed" : 0,
		"dexterity" : 0,
		"vitality" : 0
	}
	
	for stat in stats_node.get_children():
		stat.queue_free()
	
	for stat in bonus.keys():
		var stat_instance = stat_node.instance()
		stats_node.add_child(stat_instance)
		stat_instance.Set(stat, potential[stat])

func _on_Close_pressed():
	GameUI.Popup(GameUI.game_node.instance())
