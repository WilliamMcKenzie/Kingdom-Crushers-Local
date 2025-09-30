extends VBoxContainer

var stat_node = load("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/Stats/Stat.tscn")

func Set(stats, multipliers):
	for stat in stats.keys():
		var stat_instance = stat_node.instance()
		var amount = stats[stat]
		var bonus = multipliers.stats if "stats" in multipliers else 0
		
		add_child(stat_instance)
		stat_instance.SetStat(stat, amount, bonus)
