extends Node

var audio_files = {
	"menu_theme" : [preload("res://Assets/audio/Songs/menu_theme.mp3")],
	"level_up" : [preload("res://Assets/audio/Misc/level_up.wav")],
	"loot" : [preload("res://Assets/audio/Misc/loot.wav")],
	"bow" : [preload("res://Assets/audio/Weapons/bow-1.wav")],
	"staff" : [preload("res://Assets/audio/Weapons/staff-1.ogg")],
	"sword" : [preload("res://Assets/audio/Weapons/sword-1.wav")],
}

var clock_sync_timer = 0
var playing_music = false

func Play(audio_name):
	if audio_name in audio_files and SettingsHandler.audio:
		var audio_player = AudioStreamPlayer.new()
		var files = audio_files[audio_name]
		
		audio_player.name = audio_name
		audio_player.stream = files[randi() % len(files)]
		audio_player.connect("finished", self, "RemoveNode", [audio_player])
		add_child(audio_player)
		audio_player.play()

func RemoveNode(node):
	node.queue_free()
