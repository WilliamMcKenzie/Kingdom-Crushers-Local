extends HBoxContainer

var preview_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Preview/CharacterPreview.tscn")

func Set(classname):
	var data = ClientData.GetCharacter(classname)
	var previews = data.quests.values()
	
	for preview in previews:
		var instance = preview_node.instance()
		var show = AccountHandler.data.classes[preview]
		
		add_child(instance)
		instance.Set(preview, show)
