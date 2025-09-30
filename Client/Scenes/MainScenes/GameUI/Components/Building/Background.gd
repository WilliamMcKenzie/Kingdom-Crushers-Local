extends TextureButton

onready var building_node = get_parent()

var last_tile = Vector2.ZERO
var last_placement = 0
var dragging

func _exit_tree():
	var preview_node = GameHandler.instance_node.get_node_or_null("PlacementPreview")
	preview_node.set_cell(last_tile.x, last_tile.y, -1)

func can_drop_data(position, data):
	return true
	
func drop_data(position, type):
	position = CalculateGamePosition(position, type)
	last_placement = OS.get_system_time_msecs()
	building_node.Place(position, type)

func CalculateGamePosition(position, type):
	if not ClientData.GetBuilding(type): type = "storage"
	var data = ClientData.GetBuilding(type)
	var player = GameHandler.player_node
	
	var screen_size = OS.window_size
	var base_screen_size = Vector2(1920, 1080)
	
	var screen_ratio = screen_size.x / screen_size.y
	var base_screen_ratio = base_screen_size.x / base_screen_size.y
	
	if screen_ratio > base_screen_ratio:
		screen_size.x = (screen_size.x / screen_size.y) * base_screen_size.y
		screen_size.y = base_screen_size.y
	else:
		screen_size.y = (screen_size.y / screen_size.x) * base_screen_size.x
		screen_size.x = base_screen_size.x
	
	var offset_position = position - screen_size / 2
	var result = offset_position * 0.075 / SettingsHandler.zoom + player.global_position
	var tile_coord = result / 8
	var tile_result = Vector2(round(tile_coord.x - 0.5), round(tile_coord.y - 1))
	var building_result = (Vector2(round(tile_coord.x - 0.5), round(tile_coord.y - 1)) * 8) + Vector2(4, 4)
	
	return (
		tile_result 
		if "tile" in data 
		else building_result
	)

func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	var brush = building_node.selected_building
	var preview_node = GameHandler.instance_node.get_node_or_null("PlacementPreview")
	var data = ClientData.GetBuilding(brush)
	var tile_pos = CalculateGamePosition(mouse_position, "grass")
	var tile = (
		data.tile
		if (
			brush
			and data
			and "tile" in data
		)
		else 7
	)
	var valid = (
		dragging
		and OS.get_system_time_msecs() - last_placement > 100
		and brush
	)
	
	if valid:
		last_placement = OS.get_system_time_msecs()
		building_node.Place(CalculateGamePosition(mouse_position, brush))
	
	if preview_node and tile_pos != last_tile and brush:
		preview_node.set_cell(tile_pos.x, tile_pos.y, tile)
		preview_node.set_cell(last_tile.x, last_tile.y, -1)
		last_tile = tile_pos

func _on_Background_button_down():
	var position = get_global_mouse_position()
	var brush = building_node.selected_building
	var valid = (
		OS.get_system_time_msecs() - last_placement > 200
		and brush
	)
	
	dragging = true
	if valid:
		last_placement = OS.get_system_time_msecs()
		building_node.Place(CalculateGamePosition(position, brush))

func _on_Background_button_up():
	dragging = false
