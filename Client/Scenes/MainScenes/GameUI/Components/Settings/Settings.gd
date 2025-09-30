extends Control

var home_node = preload("res://Scenes/MainScenes/Home/Home.tscn")

onready var root = get_node("/root/SceneHandler")
onready var settings_node = get_node("Container/VBoxContainer/ScrollContainer/Settings")

var saved = {}
var settings = [
	{
		"title" : "Max FPS",
		"description" : "Lower max fps provides more constistency.",
		"data" : {
			"type" : "input",
			"default" : 60,
		}
	},
	{
		"title" : "Camera Zoom",
		"description" : "How far you can see.",
		"data" : {
			"type" : "input",
			"default" : 1,
		}
	},
	{
		"title" : "VSync",
		"description" : "VSync can reduce screen tearing, may lower performance.",
		"data" : {
			"type" : "checkbox",
			"default" : true,
		}
	},
	{
		"title" : "Hide Players",
		"description" : "Hiding other players can improve performance.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Hide Player Shots",
		"description" : "Hiding other players shots can improve performance.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Auto Open Chests",
		"description" : "Automatically open any loot you walk over.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Open Inventory",
		"description" : "Keybind to open your inventory.",
		"data" : {
			"type" : "keybind",
			"default" : OS.find_scancode_from_string("B"),
		}
	},
	{
		"title" : "Interact",
		"description" : "Keybind to enter dungeons and talk to npcs.",
		"data" : {
			"type" : "keybind",
			"default" : OS.find_scancode_from_string("I"),
		}
	},
	{
		"title" : "Use Ability",
		"description" : "Keybind to activate your helmet ability.",
		"data" : {
			"type" : "keybind",
			"default" : OS.find_scancode_from_string("SPACE"),
		}
	},
	{
		"title" : "Return To Port",
		"description" : "Keybind to escape danger.",
		"data" : {
			"type" : "keybind",
			"default" :  OS.find_scancode_from_string("R"),
		}
	},
	{
		"title" : "Show Joysticks",
		"description" : "Enable/disable joystick opacity",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
	{
		"title" : "Show Buttons",
		"description" : "Enable/disable button opacity",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
	{
		"title" : "Smoothing",
		"description" : "Enable/disable enemy & player interpolation",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
	{
		"title" : "Audio",
		"description" : "Enable/disable eudio",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
]
var settingsREAL = [
	{
		"title" : "Max FPS",
		"description" : "Lower max fps provides more constistency.",
		"data" : {
			"type" : "input",
			"default" : 60,
		}
	},
	{
		"title" : "VSync",
		"description" : "VSync can reduce screen tearing, may lower performance.",
		"data" : {
			"type" : "checkbox",
			"default" : true,
		}
	},
	{
		"title" : "Hide Players",
		"description" : "Hiding other players can improve performance.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Hide Player Shots",
		"description" : "Hiding other players shots can improve performance.",
		"data" : {
			"type" : "checkbox",
			"default" : false,
		}
	},
	{
		"title" : "Show Buttons",
		"description" : "Enable/disable button opacity",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
	{
		"title" : "Enemy Smoothing",
		"description" : "Enable/disable enemy movement interpolation",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
	{
		"title" : "Audio",
		"description" : "Enable/disable eudio",
		"data" : {
			"type" : "checkbox",
			"default" :  true,
		}
	},
]
var setting_scenes = {
	"checkbox" : preload("res://Scenes/MainScenes/GameUI/Components/Settings/Components/Checkbox.tscn"),
	"input" : preload("res://Scenes/MainScenes/GameUI/Components/Settings/Components/Input.tscn"),
	"slider" : preload("res://Scenes/MainScenes/GameUI/Components/Settings/Components/Slider.tscn"),
	"keybind" : preload("res://Scenes/MainScenes/GameUI/Components/Settings/Components/Keybind.tscn")
}

func _ready():
	GameUI.focused = true
	saved = AccountHandler.LoadSettings()
	
	for setting in settingsREAL:
		var title = setting.title
		var instance = setting_scenes[setting.data.type].instance()
		
		if title in saved:
			setting.data.default = saved[title]
		
		settings_node.add_child(instance)
		instance.settings_node = self
		instance.Set(setting)
	
	for setting in saved.keys():
		ChangeValue(setting, saved[setting])

func _exit_tree():
	GameUI.focused = false

func ChangeValue(which, value):
	saved[which] = value
	AccountHandler.SaveSettings(saved)
	
	if which == settings[0].title:
		Engine.target_fps = max(value, 10)
	elif which == settings[1].title:
		SettingsHandler.zoom = max(1, 0.7)
	elif which == settings[2].title:
		OS.vsync_enabled = value
	elif which == settings[3].title:
		SettingsHandler.hide_players = value
	elif which == settings[4].title:
		SettingsHandler.hide_player_shots = value
	elif which == settings[5].title:
		SettingsHandler.auto_open_chests = value
	elif which == settings[6].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("open_inventory")
		InputMap.action_add_event("open_inventory", event)
	elif which == settings[7].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("interact")
		InputMap.action_add_event("interact", event)
	elif which == settings[8].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("ability")
		InputMap.action_add_event("ability", event)
	elif which == settings[9].title:
		var event = InputEventKey.new()
		event.scancode = value
		
		InputMap.action_erase_events("nexus")
		InputMap.action_add_event("nexus", event)
	elif which == settings[10].title:
		SettingsHandler.joysticks = value
	elif which == settings[11].title:
		SettingsHandler.buttons = value
	elif which == settings[12].title:
		SettingsHandler.smoothing = value
	elif which == settings[13].title:
		SettingsHandler.audio = value

func _on_Home_pressed():
	Server.network.disconnect_from_host()
	root.SwitchScene(home_node.instance())

func _on_Close_pressed():
	GameUI.Popup(GameUI.game_node.instance())
