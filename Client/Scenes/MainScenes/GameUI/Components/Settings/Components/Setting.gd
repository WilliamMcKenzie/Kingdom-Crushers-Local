extends HBoxContainer

var settings_node

onready var title_node = get_node("VBoxContainer/Title")
onready var description_node = get_node("VBoxContainer/Description")
onready var checkbox_node = get_node_or_null("CheckBox")
onready var input_node = get_node_or_null("Input")
onready var keybind_node = get_node_or_null("Trigger")
onready var slider_node = get_node_or_null("Slider")

export var setting_default = 0
var current_key = ""
var listening = false
var setting

func Set(data):
	var description = data.description
	var default = data.data.default
	var title = data.title
	
	setting = title
	setting_default = default
	title_node.text = title
	description_node.text = description
	
	if checkbox_node: checkbox_node.pressed = default
	if slider_node: slider_node.value = default
	if input_node: input_node.text = str(default)
	if keybind_node:
		keybind_node.text = OS.get_scancode_string(default)
		current_key = default
	
	if keybind_node and str(OS.get_model_name()) != 'GenericDevice':
		self.queue_free()

func _on_CheckBox_pressed():
	settings_node.ChangeValue(setting, checkbox_node.pressed)

func _on_Input_text_entered(text):
	var value = float(text) if float(text) else float(setting_default)
	
	input_node.text = str(value)
	settings_node.ChangeValue(setting, value)

func _on_Trigger_pressed():
	listening = true
	keybind_node.text = "Listening for key..."

func _input(event):
	if listening and event is InputEventKey and event.pressed:
		listening = false
		current_key = event.scancode
		settings_node.ChangeValue(name, current_key)
		keybind_node.text = OS.get_scancode_string(current_key)

func _on_Trigger_focus_exited():
	listening = false
	keybind_node.text = OS.get_scancode_string(current_key)

func _on_Slider_value_changed(value):
	settings_node.ChangeValue(setting, value)
