extends HBoxContainer

onready var amount_node = get_node("VBoxContainer/Visuals/HBoxContainer/Amount")
onready var bonus_node = get_node("VBoxContainer/Visuals/HBoxContainer/Bonus")
onready var stat_node = get_node("VBoxContainer/Visuals/Stat")
onready var bar_node = get_node("VBoxContainer/Visuals/Bar")
onready var increase_node = get_node("Increase")
onready var animation_node = get_node("AnimationPlayer")

var current_stat
var data = {
	"health" : ["HP", "HITPOINTS", Color("ff3d3d")],
	"attack" : ["PWR", "POWER", Color("fc8b0e")],
	"defense" : ["RES", "RESISTANCE", Color("3e76dd")],
	"speed" : ["SPD", "SPEED", Color("fcda0e")],
	"dexterity" : ["ROF", "RATE OF FIRE", Color("4ea63f")],
	"vitality" : ["RGN", "REGEN", Color("e4566c")],
}

func Set(stat, potential):
	current_stat = stat
	var amount = GameHandler.character.stats[stat]
	var bonus = GameHandler.player_node.stats[stat] - amount
	var stylebox = StyleBoxFlat.new()
	var bonus_sign = "+" if bonus > 0 else "-"
	
	bonus_node.visible = bonus != 0
	bonus_node.text = bonus_sign + str(bonus)
	bonus_node.add_color_override("font_color", Color("8aff94") if bonus > 0 else Color("ff8a8a"))
	
	amount_node.text = str(amount)
	stylebox.bg_color = data[stat][2]
	stat_node.text = data[stat][0]
	stat_node.add_color_override("font_color", data[stat][2])
	bar_node.add_stylebox_override("fg", stylebox)
	bar_node.value = amount
	bar_node.max_value = potential

func _on_Stat_mouse_entered():
	stat_node.text = data[current_stat][1]

func _on_Stat_mouse_exited():
	stat_node.text = data[current_stat][0]

func _on_Increase_pressed():
	GameUI.Ascended()
	Server.Send("IncreaseStat", current_stat)
