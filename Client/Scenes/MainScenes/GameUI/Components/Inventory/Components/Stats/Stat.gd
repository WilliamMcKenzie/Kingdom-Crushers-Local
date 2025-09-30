extends HBoxContainer

onready var stat_node = get_node("Stat")
onready var amount_node = get_node("Amount")
onready var bonus_node = get_node("Bonus")

var data = {
	"health" : ["HP", "HITPOINTS", Color("ff3d3d")],
	"attack" : ["PWR", "POWER", Color("fc8b0e")],
	"defense" : ["RES", "RESISTANCE", Color("3e76dd")],
	"speed" : ["SPD", "SPEED", Color("fcda0e")],
	"dexterity" : ["ROF", "RATE OF FIRE", Color("4ea63f")],
	"vitality" : ["RGN", "REGEN", Color("e4566c")],
}

func SetStat(stat, amount, bonus):
	var amount_sign = "+" if amount > 0 else "-"
	var bonus_sign = "+" if bonus > 0 else "-"
	
	stat_node.text = data[stat][0]
	stat_node.add_color_override("font_color", data[stat][2])
	amount_node.text = amount_sign + str(abs(amount))
	bonus_node.text = amount_sign + str(abs((bonus - 1) * amount))
	bonus_node.add_color_override("font_color", ClientData.GetCharacter(GameHandler.character.class).color)
	bonus_node.visible = bonus > 0
