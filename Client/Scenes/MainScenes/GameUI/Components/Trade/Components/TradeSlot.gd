extends TextureButton

onready var touchscreen_button = get_node("TouchScreenButton")
onready var background_node = get_node("Background")
onready var icon_node = get_node("Icon")

var inactive = Color(131.0/255,131.0/255,131.0/255)
var active = Color(1,1,1)
var inventory_node
var parent
var index
var item

func _ready():
	if GameHandler.is_mobile: touchscreen_button.connect("pressed", self, "Interaction")
	else: connect("pressed", self, "Interaction")

func Activate(): icon_node.modulate = active
func Deactivate(): icon_node.modulate = inactive

func Interaction():
	if not item:
		return
	
	if parent == "inventory": inventory_node.Toggle(index, self)
	else: inventory_node.InspectItem(item, parent)

func SetItem(_item):
	item = _item
	
	if not item:
		icon_node.visible = false
		background_node.visible = true
	else:
		icon_node.visible = true
		background_node.visible = false
		UtilityFunctions.SetTextureData(icon_node, ClientData.GetItem(item.item).path)
	
