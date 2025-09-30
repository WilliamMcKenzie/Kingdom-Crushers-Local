extends CanvasLayer

onready var home_node = get_parent()

var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")
var shop_node = load("res://Scenes/MainScenes/Home/Components/Shop/Shop.tscn")
var character_selection_node = load("res://Scenes/MainScenes/Home/Components/CharacterSelection/CharacterSelection.tscn")
var character_node = load("res://Scenes/MainScenes/Home/Components/CharacterSelection/Components/Character.tscn")
var create_node = load("res://Scenes/MainScenes/Home/Components/CharacterSelection/Components/Create.tscn")
var buy_node = load("res://Scenes/MainScenes/Home/Components/CharacterSelection/Components/Buy.tscn")

onready var character_container = get_node("CharacterContainer")
onready var gold_node = get_node("NavbarContainer/Navbar/Gold/HBoxContainer/Label")
onready var buy_gold_node = get_node("NavbarContainer/Navbar/BuyGold")
onready var back_node = get_node("NavbarContainer/Navbar/Back")
onready var scroll_left = get_node("Arrows/Left")
onready var scroll_right = get_node("Arrows/Right")

func _ready():
	Populate()
	UpdateArrows()
	gold_node.text = str(AccountHandler.data.gold)

func _on_Menu_pressed():
	home_node.Popup(main_menu_node.instance())

func _on_Gold_pressed():
	home_node.Popup(shop_node.instance())

var index = 0
var character_slots = 0
var characters = []
func Populate():
	characters = AccountHandler.data.characters
	character_slots = AccountHandler.data.character_slots
	
	for child in character_container.get_children():
		child.queue_free()
	
	if len(characters) > index:
		AddCharacter(index)
	else:
		NoMoreCharacters()

func UpdateActive(new):
	new.character_selection_node = self
	new.home_node = home_node
	
	for child in character_container.get_children():
		child.queue_free()
	character_container.add_child(new)

func AddCharacter(i):
	var character_instance = character_node.instance()
	character_instance.character = characters[i]
	character_instance.character_index = i
	character_instance.name = str(i)
	UpdateActive(character_instance)

func NoMoreCharacters():
	if character_slots > index:
		var create_instance = create_node.instance()
		UpdateActive(create_instance)
	else:
		var buy_instance = buy_node.instance()
		UpdateActive(buy_instance)

func UpdateArrows():
	if index == 0:
		scroll_left.disabled = true
	else:
		scroll_left.disabled = false
	
	if index == character_slots:
		scroll_right.disabled = true
	else:
		scroll_right.disabled = false

func _on_Left_pressed():
	index -= 1
	UpdateArrows()
	if index > len(characters) - 1:
		NoMoreCharacters()
	else:
		AddCharacter(index)

func _on_Right_pressed():
	index += 1
	UpdateArrows()
	if index < len(characters):
		AddCharacter(index)
	else:
		NoMoreCharacters()

func Disable():
	scroll_left.disabled = true
	scroll_right.disabled = true
	buy_gold_node.disabled = true
	back_node.disabled = true
	for child in character_container.get_children():
		child.Disable()

func Return():
	Populate()
	UpdateArrows()
	gold_node.text = str(AccountHandler.data.gold)
