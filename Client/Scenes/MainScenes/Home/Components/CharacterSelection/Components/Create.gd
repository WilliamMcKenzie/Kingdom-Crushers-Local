extends PanelContainer

var home_node
var character_selection_node

func CreateCharacter():
	var home_node = get_parent().get_parent()
	var email = home_node.email
	var password = home_node.password
	Gateway.GatewayRequest(email, password, 2)

func _on_Create_pressed():
	Gateway.CreateCharacter(character_selection_node)
