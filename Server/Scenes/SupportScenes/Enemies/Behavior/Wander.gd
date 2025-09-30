extends Node2D

enum {
	IDLE,
	ENGAGE
}

var current_state = ENGAGE
#onready var player_detection_zone = $Ai/PlayerDetection
#onready var hitbox_zone = $EnemyHitbox

var wander_range = 15
var initial_position
var target
var velocity = Vector2(1000, 1000)

func _ready():
	initial_position = position
	target = position

func DealDamage(damage, player_id):
	get_parent().get_parent().get_parent().enemy_list[name]["Health"] -= damage
	if get_parent().get_parent().get_parent().enemy_list[name]["Health"] < 1:
		queue_free()

func ShootProjectile():
	var projectile_data = {
		"Damage":0,
		"Position":position,
		"Projectile":"Arrow",
		"TargetPosition":target,
		"Direction":(target - position).normalized(),
		"TileRange":1
	}
	get_parent().get_parent().get_parent().SpawnEnemyProjectile(projectile_data, name)

var shot_cooldown = {
	"Arrow" : [0, 0.5]
}
func EnemyCombat():
	if OS.get_system_time_secs() - shot_cooldown["Arrow"][0] > shot_cooldown["Arrow"][1]:
		shot_cooldown["Arrow"][0] = OS.get_system_time_secs()
		ShootProjectile()

func _physics_process(delta):
	if current_state == ENGAGE:
		
		EnemyCombat()
		
		var y_move = -sin(position.angle_to_point(target)) * 0.2
		var x_move = -cos(position.angle_to_point(target)) * 0.2
		velocity = Vector2(x_move, y_move)
		
		position += velocity
		if get_parent().get_parent().get_parent().enemy_list.has(name):
			get_parent().get_parent().get_parent().enemy_list[name]["Position"] = position

		if (target - position).length() <= 2:
			if (initial_position-position).length() >= wander_range:
				target = initial_position
			else:
				target = position + Vector2(rand_range(-7,7),rand_range(-7,7))
func _on_PlayerDetection_area_entered(area):
	pass
	
func _on_PlayerDetection_area_exited(area):
	pass

func _on_Hitbox_area_entered(area):
	if "player_id" in area.get_parent():
		DealDamage(area.get_parent().damage, area.get_parent().player_id)
