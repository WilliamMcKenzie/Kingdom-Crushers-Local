extends VBoxContainer

var effect_node = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/HelmetInfo/Effect.tscn")

onready var effects_node = get_node("Effects")

func Set(item):
	var buffs = item.buffs
	
	for effect in buffs.keys():
		var effect_instance = effect_node.instance()
		var buff = buffs[effect]
		var duration = buff.duration
		var radius = buff.range
		
		effects_node.add_child(effect_instance)
		effect_instance.SetEffect(effect, duration, radius)
