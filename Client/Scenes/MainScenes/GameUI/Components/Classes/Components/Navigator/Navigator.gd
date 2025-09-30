extends VBoxContainer

var class_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Navigator/Components/ClassButton.tscn")
var evolution_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Navigator/Components/EvolutionButton.tscn")

var class_map_inversed = {}
var class_map = {
	"Apprentice" : [0],
	
	"Noble" : [0,0],
	"Nomad" : [0,1],
	"Scholar" : [0,2],
	
	"Knight": [0,0,0],
	"Paladin": [0,0,1],
	"Marauder": [0,0,2],
	
	"Ranger": [0,1,0],
	"Sentinel": [0,1,1],
	"Scout": [0,1,2],
	
	"Magician": [0,2,0],
	"Druid": [0,2,1],
	"Warlock": [0,2,2],
}

func _ready():
	for key in class_map.keys():
		class_map_inversed[str(class_map[key])] = key
	
	Set(GameHandler.character.class)

func Set(classname):
	var show_previews = GameHandler.character.ascension_stones >= ClientData.GetCharacter(classname).ascension_stones
	var class_key = []
	var key = class_map[classname]
	
	for i in range(len(key)):
		class_key.append(key.pop_front())
		var class_instance = class_node.instance()
		var icon_node = class_instance.get_node("Icon")
		
		var character = class_map_inversed[str(class_key)]
		var icon = ClientData.GetCharacter(character).icon
		
		class_instance.classname = character
		class_instance.root = get_parent()
		icon_node.texture = icon_node.texture.duplicate()
		icon_node.texture.region = Rect2(icon, Vector2(10,10))
		add_child(class_instance)
	
	if len(ClientData.GetCharacter(classname).quests):
		var evolution_instance = evolution_node.instance()
		evolution_instance.root = get_parent()
		add_child(evolution_instance)
		evolution_instance.Set(show_previews)

func _on_Close_pressed():
	GameUI.Popup(GameUI.game_node.instance())
