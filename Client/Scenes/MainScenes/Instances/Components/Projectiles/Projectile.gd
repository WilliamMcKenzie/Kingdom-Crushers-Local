extends Sprite

export var type = "enemy"
var original

onready var hitbox_node = get_node_or_null("Area2D/Hitbox")

var theoretical_position = Vector2.ZERO
var velocity = Vector2.ZERO
var time = 0
var active

var start_position
var tile_range
var direction
var piercing
var formula
var damage
var speed
var path
var spin

func _ready(): set_physics_process(false)

func UpdatePosition(delta):
	var expression = Expression.new()
	var patterns = GameHandler.projectile_patterns
	
	if not formula in patterns:
		expression.parse(formula, ["x"])
		GameHandler.projectile_patterns[formula] = expression
	else:
		expression = patterns[formula]
	
	var vertical_move_vector = speed * direction.normalized() * delta
	var horizontal_move_vector = Vector2(-velocity.y, velocity.x) * expression.execute([time * 10]) * 0.05
	
	path += vertical_move_vector
	position = path + horizontal_move_vector

func _physics_process(delta):
	time += delta
	
	var tiles_traveled = (position - start_position).length() / 8
	var done = tiles_traveled >= tile_range
	if done: return DeActivate()
	if spin: rotation_degrees += 5
	
	UpdatePosition(delta)

func Activate(data):
	var info = ClientData.GetProjectile(data.name)
	
	start_position = data.start_position
	tile_range = data.tile_range
	direction = data.direction
	piercing = data.piercing
	formula = data.formula
	damage = data.damage
	speed = data.speed
	path = data.path
	name = data.id
	
	time = 0
	position = start_position
	look_at(direction + start_position)
	velocity = direction.normalized() * speed
	
	spin = info.spin
	rotation_degrees += info.rotation
	frame_coords = info.rect.position / 10
	
	if "scale" in info:
		scale = Vector2(info.scale, info.scale)
	else:
		scale = Vector2(1,1)
	
	if type == "player":
		hitbox_node.set_deferred("disabled", false)
		hitbox_node.shape.radius = data.size
	
	active = true
	visible = true
	set_physics_process(true)

func DeActivate():
	if type == "player": hitbox_node.set_deferred("disabled", true)
	
	active = false
	visible = false
	original = false
	rotation_degrees = -45
	set_physics_process(false)

func _on_Area2D_body_entered(body):
	var collision = (
		body.name == "TileMap"
		or "object_id" in body.get_parent()
	)
	if collision: DeActivate()
