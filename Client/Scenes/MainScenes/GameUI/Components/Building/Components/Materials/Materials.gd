extends GridContainer

var material_node = preload("res://Scenes/MainScenes/GameUI/Components/Building/Components/Materials/Material.tscn")

func SetMaterials(materials):
	var inventory = GameHandler.character.inventory
	var collection = {}
	var index = 0
	
	for item in inventory:
		var id = int(item.item) if item else null
		
		if item:
			if not id in collection: collection[id] = 0
			collection[id] += 1
	
	for id in materials:
		var instance = material_node.instance()
		add_child(instance)
		
		UtilityFunctions.SetTextureData(instance, ClientData.GetItem(id).path)
		
		if id in collection:
			instance.Has(true)
			collection[id] -= 1
			
			if collection[id] == 0:
				collection.erase(id)
		else:
			instance.Has(false)
