extends VBoxContainer

onready var title_node = get_node("ClassName/Class")
onready var icon_node = get_node("ClassName/TextureRect")
onready var character_node = get_node("CharacterContainer/Character")
onready var progress_node = get_node("Bar")
onready var hint_node = get_node("Hint")

func SetAchievement(achievement):
	var data = ClientData.GetAchievement(achievement)
	var stats = GameHandler.character.statistics
	
	if data.which == "enemies_killed" and "enemies" in data:
		var total = 0
		for enemy in data.enemies:
			if enemy in stats:
				total += stats[enemy]
		progress_node.max_value = data.amount
		progress_node.value = total
	elif data.which in stats:
		progress_node.max_value = data.amount
		progress_node.value = stats[data.which]
	else:
		progress_node.max_value = data.amount
		progress_node.value = 0

func Set(classname, show):
	var data = ClientData.GetCharacter(classname)
	
	if show:
		icon_node.texture = icon_node.texture.duplicate()
		icon_node.texture.region = Rect2(data.icon, Vector2(10,10))
		icon_node.visible = true
		
		character_node.modulate = Color("ffffff")
		
		title_node.add_color_override("font_color", data.color)
		title_node.text = classname
		
		hint_node.text = data.teaser.replace("Discover", "Unlock")
	hint_node.text = data.teaser
	
	character_node.SetCharacterClass(classname)
	character_node.ColorGear(data.example_colors)
	UtilityFunctions.SetSpriteData(character_node, data.path)
	SetAchievement("Unlock " + classname)
