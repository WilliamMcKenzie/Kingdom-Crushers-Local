extends TextureButton

onready var touchscreen_button = get_node("TouchScreenButton")
onready var icon_node = get_node("Icon")
onready var background_node = get_node("Background")

func SetItem(item):
	if not item:
		icon_node.visible = false
		background_node.visible = true
	else:
		icon_node.visible = true
		background_node.visible = false
		UtilityFunctions.SetTextureData(icon_node, ClientData.GetItem(item.item).path)
