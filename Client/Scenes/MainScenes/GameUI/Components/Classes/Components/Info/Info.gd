extends PanelContainer

var strength_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Info/Strength.tscn")

onready var character_node = get_node("VBoxContainer/CharacterContainer/Character")
onready var class_node = get_node("VBoxContainer/HBoxContainer/Class")
onready var icon_node = get_node("VBoxContainer/HBoxContainer/Icon")
onready var multiplier_node = get_node("VBoxContainer/Multipliers")
onready var description_node = get_node("VBoxContainer/Description")
onready var strengths_node = get_node("VBoxContainer/Strengths")

var stats = ["health", "attack", "defense", "speed", "dexterity", "vitality"]
var max_stats = {
	"health" : 0,
	"attack" : 0,
	"defense" : 0,
	"speed" : 0,
	"dexterity" : 0,
	"vitality" : 0
}

func _ready():
	for classname in ClientData.class_map.keys():
		var class_stats = ClassStats(classname)
		
		for stat in stats:
			if class_stats[stat] > max_stats[stat]:
				max_stats[stat] = class_stats[stat]

func Set(classname):
	var data = ClientData.GetCharacter(classname)
	var multipliers = data.multipliers
	var tracker = {}
	
	character_node.SetCharacterClass(classname)
	character_node.ColorGear(data.example_colors)
	UtilityFunctions.SetSpriteData(character_node, data.path)
	
	icon_node.texture.region = Rect2(data.icon, Vector2(10,10))
	class_node.add_color_override("font_color", data.color)
	class_node.text = classname
	description_node.text = data.description
	
	for type in multipliers.keys():
		var values = multipliers[type]
		for multiplier in values.keys():
			var value = str((values[multiplier] - 1) * 100)
			var id = multiplier + value
			
			if id in tracker:
				tracker[id].types.append(type)
			else:
				tracker[id] = {
					"value" : value,
					"types" : [ type ],
					"multiplier" : multiplier
				}
	
	for id in tracker.keys():
		var types_string = ""
		var value = tracker[id].value
		var types = tracker[id].types
		var multiplier = tracker[id].multiplier.capitalize()
		var text_node = Label.new()
		
		for type in types:
			if types_string != "": types_string += "/"
			types_string += type
		
		text_node.text = "+%s%% %s %s" % [ value, types_string, multiplier ]
		text_node.align = Label.ALIGN_CENTER
		multiplier_node.add_child(text_node)
	
	var class_stats = ClassStats(classname)
	var strengths = Strengths(class_stats)
	
	for strength in strengths:
		var strength_instance = strength_node.instance()
		strengths_node.add_child(strength_instance)
		strength_instance.Set(strength, class_stats[strength], max_stats[strength])

func ClassStats(classname):
	var class_stats = {
		"health" : 0,
		"attack" : 0,
		"defense" : 0,
		"speed" : 0,
		"dexterity" : 0,
		"vitality" : 0
	}
	
	var key = ClientData.class_map[classname].duplicate()
	for i in range(len(key)):
		var new_character = ClientData.class_map_inversed[key]
		var new_character_stats = ClientData.GetCharacter(new_character).bonus_stats
		for stat in stats:
			class_stats[stat] += new_character_stats[stat]
		key.pop_back()
	
	return class_stats

func Strengths(stats):
	var strengths = []
	var strength_values = []
	var strengths_map = {}
	
	for stat in stats:
		if stats[stat] < max_stats[stat] * 0.2: continue
		
		var key = stats[stat] / (max_stats[stat] * 1.0)
		
		strength_values.append(key)
		if key in strengths_map:
			strengths_map[key].append(stat)
		else:
			strengths_map[key] = [stat]
	strength_values.sort()
	strength_values.invert()
	
	for strength in strength_values:
		if strength in strengths_map:
			var stat = strengths_map[strength]
			strengths_map.erase(strength)
			strengths += stat
			
			if len(strengths) >= 3: break
	
	return strengths
