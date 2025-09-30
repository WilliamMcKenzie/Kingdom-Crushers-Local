extends Label

var colors = {
	"damage" : Color("f12114"),
	"exp" : Color("14cdf1"),
	"level" : Color("ff8828"),
	"ascension" : Color("44d768"),
	"gold" : Color("f1ee14")
}

func _ready():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "rect_position", self.rect_position, Vector2(0, -30) + self.rect_position, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func Set(which):
	add_color_override("font_color", colors[which])
