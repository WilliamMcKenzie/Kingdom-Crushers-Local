extends CanvasLayer

onready var home_node = get_parent()

var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")
var offer_node = load("res://Scenes/MainScenes/Home/Components/Shop/Components/Offer.tscn")

onready var offer_container = get_node("MarginContainer/Box")
onready var gold_node = get_node("NavbarContainer/Navbar/Row1/Gold/HBoxContainer/Label")

var offers = [
	{
		"title" : "5500 Gold",
		"description" : "5500 units of in game gold currency.",
		"price" : 50,
		"icon" : Rect2(Vector2(0,220), Vector2(10,10)),
		"gplay_id" : "5500_gold",
		"link" : "https://buy.stripe.com/bIYdT44eJ3hV0X68wB"
	},
	{
		"title" : "1000 Gold",
		"description" : "1000 units of in game gold currency.",
		"price" : 10,
		"icon" : Rect2(Vector2(0,220), Vector2(10,10)),
		"gplay_id" : "1000_gold",
		"link" : "https://buy.stripe.com/bIY02e7qV8CfbBK148"
	},
	{
		"title" : "300 Gold",
		"description" : "300 units of in game gold currency.",
		"price" : 5,
		"icon" : Rect2(Vector2(0,220), Vector2(10,10)),
		"gplay_id" : "300_gold",
		"link" : "https://buy.stripe.com/cN24iu8uZ6u70X6dQW"
	},
]

func _ready():
	gold_node.text = str(AccountHandler.data.gold)
	
	for offer in offers:
		var offer_instance = offer_node.instance()
		offer_instance.shop_node = self
		offer_container.add_child(offer_instance)
		offer_instance.SetOffer(offer)

func _on_Back_pressed():
	home_node.Popup(main_menu_node.instance())

func Return():
	gold_node.text = str(AccountHandler.data.gold)
