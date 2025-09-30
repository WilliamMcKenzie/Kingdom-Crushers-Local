extends HBoxContainer

onready var icon_node = get_node("Icon")
onready var title_node = get_node("VBoxContainer/Title")
onready var description_node = get_node("VBoxContainer/Description")
onready var gold_node = get_node("HBoxContainer/Gold")
onready var progress_node = get_node("Progress")

func Completed():
	modulate = Color("ffffff")

func Set(achievement):
	var account_data = AccountHandler.data
	var stats = account_data.statistics
	var classes = account_data.classes
	var data = ClientData.GetAchievement(achievement)
	
	title_node.text = achievement
	gold_node.text = str(data.gold)
	description_node.text = data.description
	icon_node.texture = icon_node.texture.duplicate()
	icon_node.texture.region = Rect2(data.icon, Vector2(10,10))
	
	if data.which == "classes_unlocked":
		var total = 0
		
		for classname in data.classes:
			if classname in classes and classes[classname]: total += 1
		
		progress_node.text = "%d/%d" % [total, data.amount]
	elif data.which == "enemies_killed":
		var total = 0
		for enemy in data.enemies:
			if enemy in stats: total += stats[enemy]
		
		progress_node.text = "%d/%d" % [total, data.amount]
	
	elif data.which in stats:
		progress_node.text = "%d/%d" % [stats[data.which], data.amount]
	else:
		progress_node.text = "%d/%d" % [0, data.amount]
