extends PanelContainer

onready var label = get_node("VBoxContainer/HBoxContainer/Stones")
onready var description = get_node("VBoxContainer/Label")

func _ready():
	var stones = ClientData.GetCharacter(GameHandler.character.class).ascension_stones
	var current_stones = GameHandler.character.ascension_stones
	
	label.text = "%d/%d" % [current_stones, stones]
	description.text = "You need to consume %d more ascension stones to be able to unlock a new class." % [stones - current_stones]
