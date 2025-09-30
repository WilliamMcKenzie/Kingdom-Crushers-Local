extends Sprite

var texture_params = {
	
}

var unique_texture_params = {
	
}

var default_texture_params = {
	
}

var color_params = {
	
}

var unique_color_params = {
	
}

var default_color_params = {
	
	"helmetDarkOrigin" : RgbToColor(0, 0, 255.0),
	"helmetDarkNew" : RgbToColor(116.0, 109.0, 109.0),
	
	"helmetLightOrigin" : RgbToColor(0, 255.0, 255.0),
	"helmetLightNew" : RgbToColor(142.0, 143.0, 140.0),
	
	"helmetMediumOrigin" : RgbToColor(255.0, 0, 255.0),
	"helmetMediumNew" : RgbToColor(127.0, 127.0, 127.0),
	
	"bodyLightOrigin" : RgbToColor(255.0, 255.0, 255.0),
	"bodyLightNew" : RgbToColor(198.0, 198.0, 198.0),
	
	"bodyMediumOrigin" : RgbToColor(255.0, 255.0, 0),
	"bodyMediumNew" : RgbToColor(183.0, 180.0, 178.0),
	
	"bandOrigin" : RgbToColor(0, 0, 0),
	"bandNew" : RgbToColor(144.0, 81.0, 38.0),
	
	"weaponOrigin" : RgbToColor(255.0, 0, 0),
	"weaponNew" : RgbToColor(142.0, 143.0, 140.0),
	
	"weaponSecondaryOrigin" : RgbToColor(0, 255.0, 0),
	"weaponSecondaryNew" : RgbToColor(116.0, 64.0, 30.0),
}

func GetParams():
	return {
		"TextureParams" : unique_texture_params,
		"ColorParams" : unique_color_params,
	}

func SetParams(params):
	texture_params = params.TextureParams
	color_params = params.ColorParams
	
	var mock_gear = {
		"params" : {
			"colors" : color_params,
			"textures" : texture_params,
		}
	}
	
	ColorGear(mock_gear)

func _ready():
	ColorGear({})

func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)
func RgbaToColor(r, g, b, a):
	return Color(r/255, g/255, b/255, a)

func SetCharacterClass(character_class):
	var character = ClientData.GetCharacter(character_class)
	var rect = character.rect
	self.set_region_rect(rect)
func SetCharacterWeapon(weapon_type):
	var rect = self.region_rect
	if weapon_type == "Sword":
		rect.position.x = 0.0
	if weapon_type == "Bow":
		rect.position.x = 80.0
	if weapon_type == "Staff":
		rect.position.x = 160.0
	self.region_rect = rect

func ColorGear(gear, _classname = null):
	if _classname != null:
		var temp = ClientData.GetCharacter(_classname).example_colors.duplicate()
		temp.merge(gear, true)
		gear = temp
	elif GameHandler.character:
		var temp = ClientData.GetCharacter(GameHandler.character.class).example_colors.duplicate()
		temp.merge(gear, true)
		gear = temp
	
	var shader_material = load("res://Resources/Renderer.tres").duplicate()
	
	self.material = shader_material
	
	#Get color params
	color_params = default_color_params.duplicate(true)
	texture_params = default_texture_params.duplicate(true)
	unique_color_params = {}
	unique_texture_params = {}
	
	if "params" in gear:
		var params = gear.params
		var colors = params.colors
		var textures = params.textures
		
		for key in colors.keys():
			color_params[key] = colors[key]
			unique_color_params[key] = colors[key]
		
		for key in textures.keys():
			texture_params[key] = textures[key]
			unique_texture_params[key] = textures[key]
	
	for slot in gear.keys():
		var item = gear[slot]
		if not item or not "item" in item: continue
		
		var item_data = ClientData.GetItem(item.item)
		var item_colors = item_data.colors
		var item_textures = item_data.textures
		
		for key in item_colors.keys():
			color_params[key] = item_colors[key]
			unique_color_params[key] = item_colors[key]
		
		for key in item_textures.keys():
			texture_params[key] = item_textures[key]
			unique_texture_params[key] = item_textures[key]
	
	for _color in color_params.keys():
		shader_material.set_shader_param(_color, color_params[_color])
	for _texture in texture_params.keys():
		shader_material.set_shader_param(_texture, load("res://Assets/items/textures/" + texture_params[_texture] + ".png"))
		shader_material.set_shader_param(_texture + "Active", true)
