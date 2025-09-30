extends VBoxContainer

var message_node = load("res://Scenes/MainScenes/GameUI/Components/Game/Chat/ChatMessage.tscn")

onready var message_container_node = get_node("ScrollContainer/ChatVerticalContainer")
onready var input_node = get_node("HBoxContainer/Input")

func Message(message, username, classname):
	var message_instance = message_node.instance()
	message_container_node.add_child(message_instance)
	message_instance.SetMessage(message, username, classname)

func _physics_process(delta):
	if Input.is_action_pressed("chat") and not GameUI.focused:
		input_node.visible = true
		input_node.grab_focus()
	if Input.is_action_pressed("command") and not GameUI.focused:
		input_node.visible = true
		input_node.grab_focus()
		input_node.text = "/"
		input_node.caret_position = 1

func _on_OpenChat_pressed():
	input_node.visible = not input_node.visible

func _on_Input_text_entered(new_text):
	Server.Message(new_text)
	input_node.text = ""
	input_node.focus_mode = Control.FOCUS_NONE
	input_node.focus_mode = Control.FOCUS_ALL

func _on_Input_focus_entered():
	GameUI.focused = true

func _on_Input_focus_exited():
	yield(get_tree().create_timer(0.1), "timeout")
	GameUI.focused = false
