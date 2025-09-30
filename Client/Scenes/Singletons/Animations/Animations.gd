extends CanvasLayer

onready var animation_node = get_node("AnimationPlayer")
onready var transition_node = get_node("Transition/HBoxContainer/Label")
onready var class_node = get_node("DiscoverClass/VBoxContainer/ClassName/Class")
onready var class_icon_node = get_node("DiscoverClass/VBoxContainer/ClassName/TextureRect")
onready var character_node = get_node("DiscoverClass/VBoxContainer/CharacterContainer/Character")
onready var achievement_node = get_node("Achievement/VBoxContainer/AchievementName/Achievement")
onready var achievement_icon = get_node("Achievement/VBoxContainer/AchievementName/Icon")
onready var arena_node = get_node("Arena")
onready var arena_container = get_node("Arena/VBoxContainer")
onready var gold_node = get_node("Arena/VBoxContainer/HBoxContainer/Gold")
onready var gold_bonus = get_node("Arena/VBoxContainer/HBoxContainer/Bonus")
onready var wave_node = get_node("Arena/VBoxContainer/Wave")

var animation_buffer = []

func _physics_process(delta):
	if arena_node.visible:
		arena_container.visible = "Game" in GameUI.active_node.name
	
	if not animation_node.is_playing() and len(animation_buffer):
		AudioHandler.Play("level_up")
		var animation = animation_buffer.pop_front()
		
		if animation.type == "DiscoverClass":
			DiscoverClass(animation.which)
		elif animation.type == "Achievement":
			Achievement(animation.which)

func _ready():
	if get_node_or_null("/root/SceneHandler"):
		animation_node.play("BootSplashStart")
		
		yield(get_tree().create_timer(1), "timeout")
		var home_node = get_node("/root/SceneHandler/Home")
		while home_node.active_node.name == "Empty" or home_node.active_node.name == "AutoLogin":
			yield(get_tree().create_timer(1), "timeout")
		
		animation_node.play("BootSplashEnding")

func DiscoverClass(classname):
	var data = ClientData.GetCharacter(classname)
	
	class_icon_node.texture = class_icon_node.texture.duplicate()
	class_icon_node.texture.region = Rect2(data.icon, Vector2(10,10))
	class_icon_node.visible = true
	
	character_node.modulate = Color("ffffff")
	
	class_node.add_color_override("font_color", data.color)
	class_node.text = classname
	character_node.SetCharacterClass(classname)
	character_node.ColorGear(data.example_colors)
	UtilityFunctions.SetSpriteData(character_node, data.path)
	
	animation_node.play("DiscoverClass")

func Achievement(which):
	var data = ClientData.GetAchievement(which)
	
	achievement_icon.texture.region = Rect2(data.icon, Vector2(10,10))
	achievement_node.text = which
	
	animation_node.play("Achievement")

func Wave(wave):
	animation_node.play("Wave")
	wave_node.text = "Wave " + str(wave + 1)

var last_place = "Alphabetium Palace"

func Transition(place):
	get_node("Transition/Background").modulate = Color("ffffff")
	transition_node.text = place
	animation_node.stop()
	animation_node.play("Transition")

var last_gold = 0
var initial_gold = 0

func NewInstance(arena):
	if arena:
		animation_node.play("Countdown")
		initial_gold = AccountHandler.data.gold
		last_gold = initial_gold
		gold_node.text = str(initial_gold)
		gold_bonus.text = ""
		arena_node.visible = true
	else:
		initial_gold = 0
		arena_node.visible = false

func Gold(new_gold):
	if initial_gold and last_gold != new_gold:
		last_gold = new_gold
		gold_node.text = str(new_gold)
		gold_bonus.text = "+%d" % [new_gold - initial_gold]
		animation_node.play("Gold")
