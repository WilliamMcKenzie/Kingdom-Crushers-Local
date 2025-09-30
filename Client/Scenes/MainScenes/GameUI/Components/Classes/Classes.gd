extends Control

var preview_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Preview/Previews.tscn")
var stones_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Stones/Stones.tscn") 
var info_node = preload("res://Scenes/MainScenes/GameUI/Components/Classes/Components/Info/Info.tscn")

onready var navigator_node = get_node("Navigator")

var active_node = Control.new()

func _ready():
	GameHandler.player_node.visible = false
	Info(GameHandler.character.class)

func _exit_tree():
	GameHandler.player_node.visible = true

func Info(classname):
	active_node.queue_free()
	active_node = info_node.instance()
	add_child(active_node)
	active_node.Set(classname)

func Previews():
	active_node.queue_free()
	active_node = preview_node.instance()
	add_child(active_node)
	active_node.Set(GameHandler.character.class)

func Stones():
	active_node.queue_free()
	active_node = stones_node.instance()
	add_child(active_node)
