extends CanvasLayer

onready var home_node = get_parent()

var login_node = load("res://Scenes/MainScenes/Home/Components/Login/LoginPopup.tscn")
var signup_node = load("res://Scenes/MainScenes/Home/Components/Signup/SignupPopup.tscn")
var guest_node = load("res://Scenes/MainScenes/Home/Components/Guest/GuestPopup.tscn")

func _ready():
	var monsters = [
		Rect2(Vector2(0, 38*3), Vector2(38,38)),
		Rect2(Vector2(38*2, 0), Vector2(38,38)),
		Rect2(Vector2(38*5, 38), Vector2(38,38)),
		Rect2(Vector2(38*3, 0), Vector2(38,38)),
		Rect2(Vector2(38*5, 38*3), Vector2(38,38)),
		Rect2(Vector2(38*3, 38*2), Vector2(38,38)),
	]
	get_node("Panel/VBoxContainer/Monster").texture.region = monsters[randi() % len(monsters)]

func _on_Login_pressed():
	home_node.Popup(login_node.instance())

func _on_Signup_pressed():
	home_node.Popup(signup_node.instance())

func _on_Guest_pressed():
	home_node.Popup(guest_node.instance())
