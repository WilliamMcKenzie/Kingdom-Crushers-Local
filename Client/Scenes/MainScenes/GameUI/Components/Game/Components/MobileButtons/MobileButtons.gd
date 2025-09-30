extends HBoxContainer

onready var helmet_icon = get_node("VBoxContainer/HelmetButton/Icon")
onready var helmet_tooltip = get_node("VBoxContainer/HelmetButton/Space")
onready var helmet_timer = get_node("VBoxContainer/HelmetButton/Timer")
onready var helmet_button = get_node("VBoxContainer/HelmetButton")
onready var home_icon = get_node("HomeButton/Icon")
onready var home_button = get_node("HomeButton")
onready var home_tooltip = get_node("HomeButton/R")
onready var misc_button = get_node("VBoxContainer/EnterButton")
onready var enter_button = get_node("VBoxContainer/EnterButton/Enter")
onready var talk_button = get_node("VBoxContainer/EnterButton/Talk")

var helmet_disabled = false
var helmet_on_cooldown = false
var dungeon_id
var dungeon_name
var npc_name
var transparent = Color(1,1,1,0)
var regular = Color(1,1,1,1)

func _physics_process(delta):
	modulate = Color("ffffff") if SettingsHandler.buttons else Color("46ffffff") 
	
	helmet_timer.text = str(round(GameHandler.helmet_cooldown))
	helmet_disabled = not GameHandler.player_node.gear.helmet if is_instance_valid(GameHandler.player_node) else false
	
	if GameHandler.in_home and "Port" != home_icon.name:
		home_icon.visible = false
		home_icon = get_node("HomeButton/Port")
		home_icon.visible = true
	elif not GameHandler.in_home and "Icon" != home_icon.name:
		home_icon.visible = false
		home_icon = get_node("HomeButton/Icon")
		home_icon.visible = true
	
	if helmet_disabled: helmet_button.visible = false
	else: helmet_button.visible = true
	
	if Input.is_action_pressed("ability") and not GameUI.focused:
		_on_HelmetButton_pressed()
	
	if Input.is_action_pressed("port") and not GameUI.focused:
		_on_HomeButton_pressed()
	
	if not helmet_on_cooldown and GameHandler.helmet_cooldown > 0:
		_on_HelmetButton_mouse_exited()
		helmet_on_cooldown = true
		helmet_timer.visible = true
		helmet_icon.modulate = transparent
	elif helmet_on_cooldown and GameHandler.helmet_cooldown <= 0:
		helmet_on_cooldown = false
		helmet_timer.visible = false
		helmet_icon.modulate = regular
	
	if dungeon_id:
		misc_button.visible = true
		
		talk_button.visible = "npc" in dungeon_id
		enter_button.visible = not "npc" in dungeon_id
	else:
		misc_button.visible = false

func _on_HelmetButton_mouse_entered():
	if not helmet_on_cooldown:
		helmet_tooltip.visible = true
		helmet_icon.visible = false

func _on_HelmetButton_mouse_exited():
	if not helmet_on_cooldown:
		helmet_tooltip.visible = false
		helmet_icon.visible = true

func _on_HomeButton_mouse_entered():
	home_tooltip.visible = true
	home_icon.visible = false

func _on_HomeButton_mouse_exited():
	home_tooltip.visible = false
	home_icon.visible = true

func _on_HelmetButton_pressed():
	if GameHandler.helmet_cooldown < 0 and GameHandler.player_node and GameHandler.player_node.gear.helmet and not GameUI.focused:
		var helmet = GameHandler.player_node.gear.helmet.item
		var data = ClientData.GetItem(helmet)
		GameHandler.helmet_cooldown = data.cooldown
		GameHandler.UseHelmet()

var last_home = 0
func _on_HomeButton_pressed():
	if OS.get_system_time_msecs() - last_home > 500:
		last_home = OS.get_system_time_msecs()
		if GameHandler.in_home:
			GameHandler.GoPort()
		else:
			GameHandler.Home()

func _on_EnterButton_pressed():
	if talk_button.visible: _on_Talk_pressed()
	else:
		if dungeon_name == "house":
			Server.Send("RecieveMessage", "/home")
		else: GameHandler.EnterInstance(dungeon_id, dungeon_name)

func _on_Talk_pressed():
	var dialogue = GameUI.dialogue_node.instance()
	dialogue.next_node = GameUI.game_node
	GameUI.Popup(dialogue)
	dialogue.Npc(dungeon_name)

func Portal(_dungeon_id, _dungeon_name):
	dungeon_id = _dungeon_id
	dungeon_name = _dungeon_name

func OffPortal(_dungeon_id, _dungeon_name):
	if dungeon_id == _dungeon_id:
		dungeon_id = null
