extends Camera2D

var index = 0
var destination = Vector2(128,72)
onready var vignette = get_node("Vignette")

func _physics_process(delta):
	position += (position.direction_to(destination) / 5) * (position.distance_to(destination) / 10)
	
	if (position.distance_to(destination)) < 10:
		destination = position
