extends HBoxContainer

onready var stat_node = get_node("Stat")
onready var bar_node = get_node("Bar")

var current_stat
var data = {
	"health" : ["HP", "HITPOINTS", Color("ff3d3d")],
	"attack" : ["PWR", "POWER", Color("fc8b0e")],
	"defense" : ["RES", "RESISTANCE", Color("3e76dd")],
	"speed" : ["SPD", "SPEED", Color("fcda0e")],
	"dexterity" : ["ROF", "RATE OF FIRE", Color("4ea63f")],
	"vitality" : ["RGN", "REGEN", Color("e4566c")],
}

func Set(stat, amount, maximum):
	current_stat = stat
	var stylebox = StyleBoxFlat.new()
	
	stylebox.bg_color = data[stat][2]
	stat_node.text = data[stat][0]
	stat_node.add_color_override("font_color", data[stat][2])
	bar_node.add_stylebox_override("fg", stylebox)
	bar_node.value = amount
	bar_node.max_value = maximum

func _on_Stat_mouse_entered():
	stat_node.text = data[current_stat][1]

func _on_Stat_mouse_exited():
	stat_node.text = data[current_stat][0]
