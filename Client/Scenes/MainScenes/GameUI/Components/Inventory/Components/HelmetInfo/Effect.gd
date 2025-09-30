extends HBoxContainer

onready var icon_node = get_node("TextureRect")
onready var label_node = get_node("Label")

var effect_textures = {
	"invincible" : Vector2(30, 190),
	"armored" : Vector2(20, 190),
	"healing" : Vector2(40, 190),
	"berserk" : Vector2(10, 190),
	"damaging" : Vector2(0, 190)
}

func SetEffect(effect, duration, radius):
	var label_text = (
		"for %ds within %d tiles" % [duration, radius]
		) if radius > 0 else (
		"for %ds to self" % [duration]
	)
	
	icon_node.texture = icon_node.texture.duplicate()
	icon_node.texture.region.position = effect_textures[effect]
	label_node.text = label_text
