extends Node2D

var object_id
export var npc_name = "tutorial_master"
export var dialogue_trigger = "Tutorial"

func _ready():
	$Area2D.connect("area_entered", self, "onNpc")
	$Area2D.connect("area_exited", self, "OffNpc")

func onNpc(area):
	if "main_player" in area.get_parent().get_parent():
		GameUI.Portal("npc" + object_id, npc_name, position)

func OffNpc(area):
	if "main_player" in area.get_parent().get_parent():
		GameUI.OffPortal("npc" + object_id, npc_name)
