extends Button

var root

onready var icon_node = get_node("Icon")

var show_previews = false

func Set(data):
	show_previews = data
	var position = Vector2(50, 210) if show_previews else Vector2(40, 210)
	icon_node.texture.region = Rect2(position, Vector2(10,10))

func _on_Evolution_pressed():
	if show_previews:
		root.Previews()
	else:
		root.Stones()
