extends Node

func OffsetProjectileAngle(base_direction, offset_vector):
	var base_angle = base_direction.angle()
	var offset_angle = offset_vector.angle()
	var new_angle = base_angle + offset_angle
	var new_direction = Vector2(cos(new_angle), sin(new_angle))
	
	return new_direction
func RgbToColor(r, g, b):
	return Color(r/255, g/255, b/255)
func RgbaToColor(r, g, b, a):
	return Color(r/255, g/255, b/255, a)
func DecorateFake(player_state, character, gear):
	var rect = player_state.sprite.rect
	var weapon_type = ServerData.GetItem(gear.weapon.item).type
	rect = ServerData.GetCharacter(character.class).rect
	player_state.sprite.class = character.class
	
	if weapon_type == "Sword":
		rect.position.x = 0.0
	if weapon_type == "Bow":
		rect.position.x = 80.0
	if weapon_type == "Staff":
		rect.position.x = 160.0
	player_state.sprite.rect = rect
	player_state.sprite.gear = gear
	player_state.sprite.level = character.level
	return player_state

var used_names = {}
func CreateBot():
	randomize()
	var random = RandomNumberGenerator.new()
	random.randomize()
	var kits = [
		{
			"weapon" : 100,
			"class" : "Apprentice"
		},
		{
			"weapon" : random.randi_range(101,103),
			"armor" : random.randi_range(500,502),
			"class" : "Noble"
		},
		{
			"weapon" : random.randi_range(103,106),
			"helmet" : random.randi_range(403,404),
			"armor" : random.randi_range(503,504),
			"class" : "Paladin"
		},
		{
			"weapon" : random.randi_range(166,169),
			"helmet" : random.randi_range(467,470),
			"armor" : random.randi_range(567,570),
			"class" : "Nomad"
		},
		{
			"weapon" : random.randi_range(133,140),
			"armor" : random.randi_range(534,537),
			"class" : "Warlock"
		},
		{
			"weapon" : random.randi_range(133,140),
			"armor" : random.randi_range(534,537),
			"helmet" : random.randi_range(434,436),
			"class" : "Druid"
		},
	]
	var names = [
		"RoggyRow",
		"Vicotious",
		"Adams",
		"Bearden",
		"Potlick",
		"Johnson",
		"Honor",
		"Luhrod",
		"CorbinPog",
		"Vikky",
		"swag",
		"Faris",
		"MinimalWage",
		"Pending125",
		"David",
		"X",
		"jeff",
		"gremlin",
		"Juix",
		"Tilok",
		"SLIPo",
		"BIGSIGMA",
		"M",
		"Sadex",
		"Flare",
		"Mike",
		"Art",
		"Knob",
		"Betons",
		"UserMan",
		"Arcane",
		"Oxy"
	]
	var bot_name = names[0]
	for _bot_name in names:
		if used_names.has(bot_name):
			bot_name = _bot_name
		else:
			used_names[bot_name] = true
			break
	
	var kit = kits[randi() % len(kits)]
	var default_account_data = {
		"username" : bot_name,
		"character_slots": 1,
		"gold": 5000,
		"finished_tutorial": false,
		"time_tracker" : {},
		"achievements": {
		},
		"statistics": {
			"tiles_covered" : 0,
			"ability_used" : 0,
			"damage_taken" : 0,
			"bow_projectiles" : 0,
			"staff_projectiles" : 0,
			"sword_projectiles" : 0,
			"projectiles_landed" : 0,
			"deaths" : 0,
		},
		"home" : {
			"whitelist" : [],
			"open_mode" : "open",
			"objects" : [
				{
					"type" : "storage",
					"position" : Vector2(12*8,12*8),
					"loot" : [
						null,
						null,
						null,
						null,
						null,
						null,
						null,
						null,
					],
				}
			],
			"tiles" : [],
			"inventory" : {
				"objects" : {
					"storage" : 0,
					"apprentice_statue" : 1,
					"noble_statue" : 0,
					"nomad_statue" : 0,
					"scholar_statue" : 0,
				},
				"tiles" : {
					"grass" : 0,
					"stone" : 0,
					"stone_wall" : 0,
					"wooden_planks" : 20,
					"wooden_wall" : 10,
				},
			}
		},
		"classes": {
			"Apprentice": true,
			
			"Noble": false,
			"Nomad": false,
			"Scholar": false,
			
			"Knight": false,
			"Paladin": false,
			"Marauder": false,
			
			"Ranger": false,
			"Sentinel": false,
			"Scout": false,
			
			"Magician": false,
			"Druid": false,
			"Warlock": false,
		},
		"characters":[{
			"stats" : {
				"health" : random.randi_range(500,1000),
				"attack" : random.randi_range(20,50),
				"defense" : 0,
				"speed" : 20,
				"dexterity" : 20,
				"vitality" : 20
			},
			"level" : random.randi_range(1,100),
			"exp" : 0,
			
			"ascension_stones" : 0,
			"used_ascension_stones" : 0,
			
			"stat_buffs" : {},
			"status_effects" : [],
			"ability_cooldown" : 0,
			
			"class" : "Apprentice",
			"statistics": {
				"tiles_covered" : 0,
				"damage_taken" : 0,
				"bow_projectiles" : 0,
				"staff_projectiles" : 0,
				"sword_projectiles" : 0,
				"projectiles_landed" : 0,
			},
			"gear" : {
				"weapon" : {
					"item" : 167,
					"id" : 123321231
				},
				"helmet" : null,
				"armor" : null
			},
			"inventory" : [
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
			]
		}],
		"graveyard":[],
	}
	var character = default_account_data.characters[0]
	for category in kit.keys():
		if character.has(category):
			character[category] = kit[category]
		elif character.gear.has(category):
			character.gear[category] = {
				"item" : kit[category],
				"id" : 123321231
			}
	return default_account_data
