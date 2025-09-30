extends Node2D

enum {
	IDLE,
	ENGAGE
}

var current_state = IDLE
onready var player_detection_zone = $Ai/PlayerDetection
onready var hitbox_zone = $Hitbox
var target
var velocity = Vector2(1000, 1000)

func DealDamage(damage, player_id):
	get_parent().get_parent().get_parent().enemy_list[name]["Health"] -= damage
	if get_parent().get_parent().get_parent().enemy_list[name]["Health"] < 1:
		queue_free()

func _physics_process(delta):
	if current_state == ENGAGE:
		
		var y_move = sin(position.angle_to_point(target.position)) * 0.2
		var x_move = cos(position.angle_to_point(target.position)) * 0.2
		velocity = Vector2(x_move, y_move)
		
		position += velocity
		if get_parent().get_parent().get_parent().enemy_list.has(name):
			get_parent().get_parent().get_parent().enemy_list[name]["Position"] = position - get_parent().get_parent().get_parent().position

func _on_PlayerDetection_area_entered(area):
	if area.get_parent().name == "PlayerCharacter":
		target = area.get_parent().get_parent()
		current_state = ENGAGE

func _on_PlayerDetection_area_exited(area):
	if area.get_parent().name == "PlayerCharacter":
		target = null
		current_state = IDLE

func _on_Hitbox_area_entered(area):
	if "player_id" in area.get_parent():
		DealDamage(area.get_parent().damage, area.get_parent().player_id)
