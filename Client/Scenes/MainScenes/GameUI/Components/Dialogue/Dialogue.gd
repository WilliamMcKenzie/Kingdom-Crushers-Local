extends Control

var question_node = load("res://Scenes/MainScenes/GameUI/Components/Dialogue/Components/Question.tscn")
var next_node

onready var character_node = get_node("HBoxContainer/Character")
onready var dialogue_node = get_node("HBoxContainer/PanelContainer/Dialogue")
onready var questions_node = get_node("Questions")
onready var animation_node = get_node("AnimationPlayer")


var mobile_versions = {
	"Use [WASD] to move." : "Drag on the left side of the screen to move.",
	"Click to attack. Take down those crabs!" : "Drag on the right side of the screen to attack. Take down those crabs!",
	"Press [SPACE] to use your helmet." : "Tap the helmet icon in the bottom right to use your helmet.",
	"Tap [R] to return to the port and head to the docks for your adventure." : "Tap the home button to return to the port and head to the docks for your adventure."
}
var speech_index = null
var subject = null
var last_start = OS.get_system_time_msecs() + 1000
var last_click = OS.get_system_time_msecs() + 1000

func _input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		var spamming = OS.get_system_time_msecs() - last_click < 500
		var misclick = OS.get_system_time_msecs() - last_start < 1000
		
		if not spamming and not misclick:
			last_click = OS.get_system_time_msecs()
			Talk()

func Npc(npc):
	var npcs = {
		"arena_master" : {
			"text" : ["Hey there! The arena is a place to endlessly battle monsters...", "It starts easy, and gets harder the more waves you clear.", "Each wave also nets you gold! Don't worry about dying, if you die it will just send you to the port."],
			"question" : ["Daily Arena", "Monthly Arena", "Cancel"],
			"character_rect" : Vector2(20,0),
		},
		"tutorial_master" : {
			"text" : ["I am the tutorial master...", "Anything you would like to know?"],
			"question" : ["Classes/Ascension", "Gameplay", "Death"],
			"character_rect" : Vector2(0,0),
		},
		"old_fisherman" : {
			"text" : ["I've been trying to catch a blue tuna for a millenium now...", "If you happen to find one, I would happily sail you to a new island...", "What do you say?"],
			"question" : ["I have one!", "I'll keep an eye out"],
			"character_rect" : Vector2(60,0),
		},
		"green_oracle" : {
			"text" : ["What's that?", "You want to combine gems?", "Come again another day, I'm feeling drowzy."],
			#"text" : ["Whats that? You regret what stats you've put your ascension stones in?", "Well I suppose I could give you a reset...", "At the small cost of 100 gold! What do you say?"],
			"question" : ["Yeah Sure", "No Thanks"],
			"character_rect" : Vector2(40,0),
		}
	}
	
	if npc in npcs:
		Subject(npcs[npc])

func Subject(data):
	if data:
		character_node.texture.region.position = data.character_rect
		last_start = OS.get_system_time_msecs()
		speech_index = 0
		subject = data
		Talk()

func Questionaire(questions):
	animation_node.play("Questions")
	
	var index = 0
	var width = 0
	speech_index += 1
	
	for question in questions_node.get_children(): question.queue_free()
	
	for question in questions:
		var question_instance = question_node.instance()
		question_instance.text = question
		question_instance.connect("pressed", self, "SelectOption", [index])
		questions_node.add_child(question_instance)
		width = max(question_instance.rect_size.x, width)
		index += 1
	
	for question in questions_node.get_children(): question.rect_min_size.x = width

func Talk():
	if len(subject.text) < speech_index: return
	elif len(subject.text) == speech_index:
		if "question" in subject: Questionaire(subject.question)
		else: GameUI.Popup(next_node.instance())
	else:
		var sentence = subject.text[speech_index]
		if GameHandler.is_mobile and sentence in mobile_versions:
			sentence = mobile_versions[sentence]
		
		animation_node.play("Talk")
		dialogue_node.text = sentence
		speech_index += 1

func SelectOption(i):
	Server.Send("Dialogue", subject.question[i])
	GameUI.Popup(next_node.instance())
