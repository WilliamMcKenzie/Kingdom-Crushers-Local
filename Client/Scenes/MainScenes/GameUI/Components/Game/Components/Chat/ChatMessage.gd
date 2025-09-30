extends HBoxContainer

onready var icon_node = get_node("HBoxContainer/TextureRect")
onready var username_node = get_node("HBoxContainer/Label")
onready var message_node = get_node("MarginContainer/Label")

func _ready():
	yield(get_tree().create_timer(8), "timeout")
	queue_free()

func SetMessage(message, username, classname):
	if "System" in username:
		icon_node.visible = false
		username_node.add_color_override("font_color", Color("#adeaea"))
		message_node.add_color_override("font_color", Color("#92c4c4"))
		username_node.text = "System"
		message_node.text = message
	elif "Enemy" == username:
		icon_node.visible = false
		username_node.add_color_override("font_color", Color("#e92c2c"))
		message_node.add_color_override("font_color", Color("#ffbaba"))
		username_node.text = UtilityFunctions.IdentifierToString(classname)
		message_node.text = message
	else:
		var color = ClientData.GetCharacter(classname).color
		var icon_coords = ClientData.GetCharacter(classname).icon
		
		icon_node.texture = icon_node.texture.duplicate()
		icon_node.texture.region = Rect2(icon_coords, Vector2(10, 10))
		username_node.add_color_override("font_color", color)
		username_node.text = username
		message_node.text = message
