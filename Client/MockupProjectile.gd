extends Sprite

func _physics_process(delta):
	if get_global_mouse_position().distance_to(self.position) <= 4:
		print("intersecting")
	else:
		print("not")
