extends PanelContainer

var stats_node = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/Stats/Stats.tscn")
var consumeable_info = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/ConsumeableInfo/ConsumableInfo.tscn")
var weapon_info = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/WeaponInfo/WeaponInfo.tscn")
var helmet_info = preload("res://Scenes/MainScenes/GameUI/Components/Inventory/Components/HelmetInfo/HelmetInfo.tscn")

onready var name_node = get_node("VBoxContainer/Name")
onready var description_node = get_node("VBoxContainer/ItemDescription")
onready var sprite_node = get_node("VBoxContainer/TextureRect")
onready var info_node = get_node("VBoxContainer/VBoxContainer")

func Inspect(item, data):
	var info_nodes = info_node.get_children()
	for node in info_nodes: node.queue_free()
	
	var bonus_color = ClientData.GetCharacter(GameHandler.character.class).color
	var multipliers = ClientData.GetMultiplier(data.item)
	var item_name = item.name
	
	var consumable = item.type == "Consumable"
	var helmet = item.type == "Helmet" or item.type == "Hat" or item.type == "Cap"
	var weapon = "projectiles" in item
	var has_stats = "stats" in item and len(item.stats)
	
	if consumable:
		var instance = consumeable_info.instance()
		info_node.add_child(instance)
	if helmet:
		var instance = helmet_info.instance()
		info_node.add_child(instance)
		instance.Set(item)
	if weapon:
		var instance = weapon_info.instance()
		info_node.add_child(instance)
		instance.Set(item, multipliers)
	if has_stats:
		var instance = stats_node.instance()
		info_node.add_child(instance)
		instance.Set(item.stats, multipliers)
	
	sprite_node.texture.region = Rect2(item.path[3] * 10, Vector2(10, 10))
	description_node.text = item.description + "\n"
	name_node.text = item.name
	
	yield(get_tree().create_timer(0.001), "timeout")
	visible = true
