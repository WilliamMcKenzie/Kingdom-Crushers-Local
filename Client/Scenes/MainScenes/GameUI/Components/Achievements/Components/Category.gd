extends Button

var root
var category

func Set(which):
	var data = ClientData.achievement_catagories[which]
	
	text = which
	icon = icon.duplicate()
	icon.region = Rect2(data.icon, Vector2(10,10))
	category = which

func _on_0_pressed():
	root.SetCategory(category)
