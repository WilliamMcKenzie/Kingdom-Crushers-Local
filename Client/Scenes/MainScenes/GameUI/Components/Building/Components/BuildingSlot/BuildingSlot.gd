extends TextureButton

onready var touchscreen_button = get_node("TouchScreenButton")
onready var quantity_node = get_node("Label")
onready var icon_node = get_node("Icon")

var empty = Color("848484")
var yellow = Color("ffe900")
var white = Color("ffffff")
var dragging = false
var last_click = 999
var building_node
var building

func _physics_process(delta): last_click += delta

func _ready():
	if GameHandler.is_mobile: touchscreen_button.connect("pressed", self, "Interaction")
	else: connect("pressed", self, "Interaction")

func get_drag_data(position):
	dragging = true
	
	if not building_node.selected_building == building:
		building_node.Select(building)
	
	var drag_texture = TextureRect.new()
	var material = icon_node.material
	drag_texture.texture = AtlasTexture.new()
	drag_texture.material = material.duplicate() if material else Material.new()
	drag_texture.texture.atlas = icon_node.texture.atlas.duplicate(true)
	drag_texture.texture.region = icon_node.texture.region
	drag_texture.rect_position = -0.5 * Vector2(70,70)
	drag_texture.rect_size = Vector2(70,70)
	drag_texture.expand = true
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	set_drag_preview(preview)
	
	return building

func Interaction():
	var doubleclick = last_click < 1
	last_click = 1
	
	if doubleclick:
		Server.Send("Craft", building)
	else: last_click = 0
	
	building_node.InspectBuilding(building)
	building_node.Select(building)

func DeInspectItem():
	building_node.OffBuilding()

func Select():
	quantity_node.add_color_override("font_color", yellow)

func Deselect():
	quantity_node.add_color_override("font_color", white)

func SetBuilding(type, quantity):
	var data = ClientData.GetBuilding(type)
	var path = data.path
	var wall = "wall" in data
	var tile = "tileset" in path[0]
	
	UtilityFunctions.SetTextureData(icon_node, path)
	icon_node.texture.region = Rect2(path[3], Vector2(260 / path[2], 260 / path[2]))
	if wall:
		icon_node.texture.region = Rect2(path[3], Vector2(10,20))
	if tile:
		icon_node.material = null
	
	if quantity == 0:
		modulate = empty
	else:
		modulate = white
	
	quantity_node.text = "x" + str(quantity)
	building = type
