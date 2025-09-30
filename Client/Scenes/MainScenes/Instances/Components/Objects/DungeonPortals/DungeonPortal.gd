extends Node2D

onready var area_node = get_node("Area2D")
onready var control_node = get_node_or_null("Control")
onready var sprite_node = get_node_or_null("Control/Sprite")

var object_id
var portal_name
var ruler
var island_translation = {
	"oranix" : Vector2(0,18),
	"vajira" : Vector2(0,36),
	"raa'sloth" : Vector2(0,54),
	"salazar" : Vector2(0,72),
	"saint_of_the_north" : Vector2(0,90),
	"pumpkin_tyrant" : Vector2(0,108),
	"oracle" : Vector2(0,126),
}

func _ready():
	randomize()
	var scale = round(rand_range(0.9, 1.2))
	
	area_node.connect("area_entered", self, "OnPortal")
	area_node.connect("area_exited", self, "OffPortal")
	
	if control_node: control_node.rect_scale = Vector2(scale, scale)
	if ruler and island_translation.has(ruler): sprite_node.region_rect.position = island_translation[ruler]

func OnPortal(area):
	if "main_player" in area.get_parent().get_parent():
		GameUI.Portal(object_id, portal_name, position)

func OffPortal(area):
	if "main_player" in area.get_parent().get_parent():
		GameUI.OffPortal(object_id, portal_name)
