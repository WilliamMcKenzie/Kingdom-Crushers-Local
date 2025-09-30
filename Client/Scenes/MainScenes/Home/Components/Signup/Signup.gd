extends CanvasLayer

onready var home_node = get_parent()

var account_node = load("res://Scenes/MainScenes/Home/Components/Account/AccountPopup.tscn")
var main_menu_node = load("res://Scenes/MainScenes/Home/Components/MainMenu/MainMenu.tscn")

onready var email_field = get_node("Panel/VBoxContainer/EmailContainer/Email")
onready var password_field = get_node("Panel/VBoxContainer/PasswordContainer/Password")
onready var verify_password_field = get_node("Panel/VBoxContainer/PasswordContainer2/Password")
onready var error_field = get_node("Panel/VBoxContainer/Error")
onready var continue_button = get_node("Panel/VBoxContainer/Continue")
onready var back_button = get_node("Panel/VBoxContainer/Back")

func _on_Back_pressed():
	home_node.Popup(account_node.instance())

func _on_Continue_pressed():
	var email = email_field.text
	var password = password_field.text
	var verified_password = verify_password_field.text
	
	if password != verified_password:
		error_field.text = "Passwords must match"
	elif len(email) < 7:
		error_field.text = "Invalid email"
	elif not "@" in email:
		error_field.text = "Invalid email"
	elif len(password) < 8:
		error_field.text = "Password too short"
	else:
		error_field.text = ""
		continue_button.disabled = true
		back_button.disabled = true
		email_field.editable = false
		password_field.editable = false
		verify_password_field.editable = false
		
		AccountHandler.email = email
		AccountHandler.password = password
		Gateway.Signup(email, password, self)

func Return():
	if AccountHandler.data:
		AccountHandler.SaveUser()
		home_node.Popup(main_menu_node.instance())
	else:
		error_field.text = "Email in use"
		continue_button.disabled = false
		back_button.disabled = false
		email_field.editable = true
		password_field.editable = true
		verify_password_field.editable = true
