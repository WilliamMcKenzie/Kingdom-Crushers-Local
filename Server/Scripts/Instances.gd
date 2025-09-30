extends Node

var chunk_sensors = {}
var free_position = Vector2(1500*8,0)
onready var server = get_node("/root/Server")

func GetFreeInstancePosition():
	free_position += Vector2(1500*8,0)
	server.instance_positions[free_position] = true
	return free_position
