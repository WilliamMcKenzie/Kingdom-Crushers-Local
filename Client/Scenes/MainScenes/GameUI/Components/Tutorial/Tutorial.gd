extends Control

onready var name_node = load("res://Scenes/MainScenes/GameUI/Components/Tutorial/Components/Name.tscn")

onready var quest_node = get_node("Quest")
onready var bars_node = get_node("HBoxContainer/Bars")
onready var backpack_node = get_node("GUIButtons/Backpack")
onready var stats_node = get_node("GUIButtons/Stats")
onready var nearby_node = get_node("GUIButtons/Nearby")
onready var toggle_node = get_node("GUIButtons/Toggle")
onready var home_node = get_node("MobileButtons/HomeButton")
onready var mobile_buttons = get_node("MobileButtons")
var step

func _ready():
	step = GameHandler.tutorial
	if step < 6: bars_node.visible = false
	if step < 7: backpack_node.visible = false
	if step < 8: mobile_buttons.visible = false
	if step < 9: quest_node.visible = false
	if step < 13: home_node.visible = false
	if step > 13: home_node.visible = false
	if step < 16: stats_node.visible = false
	if step == 17: home_node.visible = true
	nearby_node.visible = false
	toggle_node.visible = false
	
	if step == 1: Name()
	if step == 2: GameUI.Popup(name_node.instance())
	if step == 3: Basics()

func _physics_process(delta):
	if step == 4 and GameHandler.player_node.position.y < -20:
		Dialogue(["Oh no, theres an enemy!", "But don't worry, it's just a crab.", "Shoot at it and see what happens!"])

func Name():
	Dialogue(["Welcome to the kingdom, adventurer!", "I will teach you the basics. First, what is your name?!"])

func Basics():
	Dialogue(["Run forwards to get a feel of the controls!"])

func KilledCrab():
	Dialogue(["It dropped some loot...", "Go ahead and walk to the chest."])

func OverLoot():
	Dialogue(["Press the chest button in the top right to open the chest...", "Then drag the helmet into your backpack (to the right)"])

func GotHelmet():
	Dialogue(["Now that it is in your backpack, you can double click the helmet to put it on."])

func EquipHelmet():
	Dialogue(["Now you can use your helmet to give buffs...", "Use it to go fight the nature druid!", "Be careful, if your health gets to zero you will die and lose all your items."])

func KilledDruid():
	Dialogue(["The druid dropped a portal to a kingdom!", "Get your loot and head inside the portal."])

func EnterKingdom():
	Dialogue(["Follow your quest in the top left to defeat the boss...", "Quest monsters give you 3x more levels!"])

func DefeatedBoss():
	Server.SendEmpty("DoneTutorial")
	Dialogue(["You killed it! Go ahead and pick up both your rewards."])

func CollectedLoot():
	Dialogue(["Now get out of there with your valuables!", "Press the home button in the bottom right."])

func EnterHouse():
	Dialogue(["This is your house!", "You can build, and store items in chests...", "Even if you die, everything in your house will stay the same.", "Try placing down some tiles by pressing the hammer button in the top right."])

func ClosedBuild():
	Dialogue(["Now that you have made yourself at home...", "Open your backpack and double click the green stone.",])

func UsedStone():
	Dialogue(["Now you can level up one of your stats!", "Open the stats page in the top right."])

func Ascended():
	GameUI.game_node = load("res://Scenes/MainScenes/GameUI/Components/Game/Game.tscn")
	GameHandler.tutorial = -100
	Dialogue(["Good choice!", "Well I think we are done...", "Once your ready to leave press the ship button to go to the port and then enter a ship...", "Remember, if you get in trouble you can always escape to your house...", "And it's a smart choice to store spare items in case you die.", "Good luck out there!"])

func Dialogue(text):
	var dialogue = GameUI.dialogue_node.instance()
	dialogue.next_node = GameUI.game_node
	GameHandler.tutorial += 1
	GameUI.Popup(dialogue)
	dialogue.Subject({
		"text" : text,
		"character_rect" : Vector2(0,0),
	})
