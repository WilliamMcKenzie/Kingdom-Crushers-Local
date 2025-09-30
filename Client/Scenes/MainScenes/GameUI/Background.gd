extends TextureButton

func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	Server.Send("DropItem", data)

func _unhandled_input(event):
	var valid_input = (
		event is InputEventScreenTouch
		and GameUI.move_joystick != Vector2.ZERO
	)
	if valid_input: emit_signal("button_down")
