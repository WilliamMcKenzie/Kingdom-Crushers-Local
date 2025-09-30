extends CanvasLayer

onready var home_node = get_parent()

var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")
var shop_node = load("res://Scenes/MainScenes/Home/Components/Shop/Shop.tscn")
var graveyard_node = load("res://Scenes/MainScenes/Home/Components/Graveyard/Graveyard.tscn")
var character_scene = load("res://Scenes/MainScenes/Home/Components/Graveyard/Components/Character.tscn")

onready var character_container = get_node("MarginContainer/ScrollContainer/Top")
onready var gold_node = get_node("NavbarContainer/Navbar/Row1/Gold/HBoxContainer/Label")
onready var graveyard_nodes = {
	"recent" : get_node("NavbarContainer/Navbar/Row3/Recent"),
	"top" : get_node("NavbarContainer/Navbar/Row3/Top")
}

var graveyard = []
var current_graveyard = "top"

func _ready():
	graveyard = AccountHandler.data.graveyard
	gold_node.text = str(AccountHandler.data.gold)
	SwitchGraveyard("recent")

func SwitchGraveyard(which):
	graveyard_nodes[current_graveyard].disabled = false
	graveyard_nodes[which].disabled = true
	current_graveyard = which
	
	for child in character_container.get_children():
		character_container.remove_child(child)
	
	var index = 0
	for character in graveyard:
		character.index = index
		index += 1
		
	var temp_graveyard = graveyard.duplicate()
	if which == "top":
		temp_graveyard.sort_custom(sort_graveyard, "sort_graveyard")
	if which == "recent":
		temp_graveyard.invert()
	
	for character in temp_graveyard:
		var character_instance = character_scene.instance()
		character_instance.index = character.index
		character_instance.graveyard_node = self
		character_container.add_child(character_instance)
		character_instance.SetData(character, character.index)

class sort_graveyard:
	static func sort_graveyard(a, b):
		if a.level > b.level:
			return true
		return false

func _on_Back_pressed():
	home_node.Popup(main_menu_node.instance())

func _on_Recent_pressed():
	SwitchGraveyard("recent")

func _on_Top_pressed():
	SwitchGraveyard("top")

func Return():
	graveyard = AccountHandler.data.graveyard
	gold_node.text = str(AccountHandler.data.gold)
	SwitchGraveyard("recent")

func _on_BuyGold_pressed():
	home_node.Popup(shop_node.instance())
