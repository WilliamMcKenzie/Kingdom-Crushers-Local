extends Control

var home = true

var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")
var gateway_connection_failed = load("res://Scenes/MainScenes/Home/Components/ConnectionFailed/Gateway/ConnectionFailed.tscn")
var server_connection_failed = load("res://Scenes/MainScenes/Home/Components/ConnectionFailed/Server/ConnectionFailed.tscn")
var account_node = load("res://Scenes/MainScenes/Home/Components/Account/AccountPopup.tscn")
var auto_login_node = load("res://Scenes/MainScenes/Home/Components/Login/AutoLogin.tscn")

var email
var password
var gold

onready var active_node = get_node_or_null("Empty")
onready var camera = get_node("Camera2D")

func Popup(node):
	active_node.queue_free()
	active_node = node
	add_child(node)

func _ready():
	AudioHandler.Play("menu_theme")
	
	if rand_range(0, 300) > 299:
		get_node("TileMap/Bag").visible = true
	if rand_range(0, 600) > 599:
		get_node("TileMap/Bag2").visible = true
	if rand_range(0, 50) > 49:
		get_node("TileMap/Bag3").visible = true
	
	GameHandler.character = null
	GameHandler.tutorial = -9999
	GameUI.visible = false
	GameUI.game_node = load("res://Scenes/MainScenes/GameUI/Components/Game/Game.tscn")
	GameUI.Popup(GameUI.game_node.instance())
	
	if Gateway.network.get_connection_status() != Gateway.network.CONNECTION_CONNECTED:
		Gateway.Connect(self)
	else:
		camera.position = camera.destination
		GatewayConnection(true)

func _exit_tree():
	if AudioHandler.has_node("menu_theme"): AudioHandler.get_node("menu_theme").queue_free()

func AutoLogin():
	var user = AccountHandler.LoadUser()
	if user:
		var auto_login = auto_login_node.instance()
		Popup(auto_login)
		Gateway.Login(AccountHandler.email, AccountHandler.password, auto_login)
	else:
		Popup(account_node.instance())

func EnterGame(index):
	active_node.Disable()
	Server.token = null
	Gateway.GetToken(self)
	GameHandler.character_index = index

func GatewayConnection(connection_result):
	if connection_result and not AccountHandler.data:
		AutoLogin()
	elif connection_result:
		var main_menu_instance = main_menu_node.instance()
		Popup(main_menu_instance)
		Gateway.Login(AccountHandler.email, AccountHandler.password, main_menu_instance)
	else:
		Popup(gateway_connection_failed.instance())

func ServerConnection(connection_result):
	if connection_result:
		GameHandler.EnterGame()
	else:
		var server_connection_failed_instance = server_connection_failed.instance()
		server_connection_failed_instance.home_node = self
		Popup(server_connection_failed_instance)
