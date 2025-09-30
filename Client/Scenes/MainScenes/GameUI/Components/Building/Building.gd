extends Control

var inspect_node = preload("res://Scenes/MainScenes/GameUI/Components/Building/Components/InspectBuilding/InspectBuilding.tscn")
var building_slot = preload("res://Scenes/MainScenes/GameUI/Components/Building/Components/BuildingSlot/BuildingSlot.tscn")
var open_themes = {
	"open" : preload("res://Resources/UI/ButtonGreen.tres"),
	"closed" : preload("res://Resources/UI/ButtonBlue.tres")
}

onready var container_node = get_node("HouseContainer")
onready var open_node = get_node("HouseContainer/PanelContainer/VBoxContainer/Open")
onready var storage_node = get_node("HouseContainer/PanelContainer/VBoxContainer/ScrollContainer/GridContainer")

var selected_building = ""
var inspect_instance
var building
var which

func _ready():
	SwitchTiles()

func SwitchTiles():
	if which == "tiles":
		return
	
	which = "tiles"
	for building in storage_node.get_children():
		building.queue_free()
	
	SetBuildings(AccountHandler.data.home)

func SwitchObjects():
	if which == "objects":
		return
	
	which = "objects"
	for building in storage_node.get_children():
		building.queue_free()
	
	var instance = building_slot.instance()
	instance.building_node = self
	instance.name = "delete"
	instance.building = "delete"
	storage_node.add_child(TextureButton.new())
	storage_node.add_child(instance)
	storage_node.add_child(TextureButton.new())
	
	SetBuildings(AccountHandler.data.home)

func Select(type):
	var node = storage_node.get_node_or_null(selected_building)
	if node:
		node.Deselect()
	
	if type == selected_building:
		selected_building = ""
	else:
		node = storage_node.get_node_or_null(type)
		if node:
			node.Select()
		
		selected_building = type

func InspectBuilding(data):
	if not data: return
	if building: return OffBuilding()
	if not ClientData.GetBuilding(data): return
	building = ClientData.GetBuilding(data)
	
	inspect_instance = inspect_node.instance()
	container_node.add_child(inspect_instance)
	container_node.move_child(inspect_instance, 0)
	inspect_instance.Inspect(building)

func OffBuilding():
	building = null
	if is_instance_valid(inspect_instance): inspect_instance.queue_free()

func SetBuildings(data):
	var open_mode = data.open_mode
	var buildings_data = ClientData.buildings
	var objects = data.inventory.objects
	var buildings = data.inventory.tiles
	buildings.merge(objects)
	
	open_node.theme = open_themes[open_mode]
	open_node.text = open_mode.capitalize()
	
	for building in buildings_data.keys():
		var building_data = ClientData.GetBuilding(building)
		var quantity = 0
		var valid = (
			not "achievement" in building_data
			or (
				building_data.achievement in AccountHandler.data.achievements
				and AccountHandler.data.achievements[building_data.achievement]
			)
		)
		var type = "tiles" if "tileset" in building_data.path[0] else "objects"
		var instance = storage_node.get_node_or_null(building)
		
		if type == which:
			if building in buildings:
				quantity = buildings[building]
			
			if not instance:
				instance = building_slot.instance()
				instance.building_node = self
				instance.name = building
				storage_node.add_child(instance)
		
			if valid:
				instance.SetBuilding(building, quantity)
			elif "achievement" in building_data:
				instance.queue_free()

func Place(position, type = selected_building):
	if type == "delete":
		Server.Send("RemoveBuilding", position)
	else:
		Server.PlaceBuilding(type, position)

func _on_Close_pressed():
	GameUI.Popup(GameUI.game_node.instance())

func _on_Open_pressed():
	Server.SendEmpty("ToggleState")
