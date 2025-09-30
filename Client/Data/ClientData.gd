extends Node

var class_map_inversed = {}
var class_map = {
	"Apprentice" : [0],
	
	"Noble" : [0,0],
	"Nomad" : [0,1],
	"Scholar" : [0,2],
	
	"Knight": [0,0,0],
	"Paladin": [0,0,1],
	"Marauder": [0,0,2],
	
	"Ranger": [0,1,0],
	"Sentinel": [0,1,1],
	"Scout": [0,1,2],
	
	"Magician": [0,2,0],
	"Druid": [0,2,1],
	"Warlock": [0,2,2],
}

func ClassMap():
	for key in class_map.keys():
		class_map_inversed[class_map[key]] = key

var unique_tiles = {
	0 : 0,
	1 : 0.5,
}

var basic_loot_pools = {
	"none" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"lowlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"lowlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"midlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"midlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"highlands_1" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"highlands_2" : {
		"soulbound_loot" : [],
		"loot" : []
	},
	"godlands_1" : {
		"soulbound_loot" : [
			{
				"item" : -2,
				"chance" : 20,
				"threshold" : 0.3,
			},
		],
		"loot" : []
	},
	"ruler_1" : {
		"soulbound_loot" : [
			{
				"item" : -1,
				"chance" : 3,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"encounter_1" : {
		"soulbound_loot" : [
			{
				"item" : -1,
				"chance" : 2,
				"threshold" : 0.05,
			},
			{
				"item" : -2,
				"chance" : 1,
				"threshold" : 0.05,
			},
			{
				"item" : 3,
				"chance" : 300,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"encounter_2" : {
		"soulbound_loot" : [
			{
				"item" : -1,
				"chance" : 1,
				"threshold" : 0.1,
			},
			{
				"item" : 0,
				"chance" : 2,
				"threshold" : 0.1,
			},
			{
				"item" : 3,
				"chance" : 1000,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
}

var extreme = 0.003
var mythic = 0.006
var rare = 0.01

var special_loot_pools = {
	"pohaku" : {
		"override" : "encounter_1",
		"soulbound_loot" : [
			{
				"item" : 143,
				"chance" : 300,
				"threshold" : 0.05,
			},
			{
				"item" : 571,
				"chance" : 300,
				"threshold" : 0.05,
			},
			{
				"item" : 4,
				"chance" : 100,
				"threshold" : 0.05,
			},
			{
				"item" : 5,
				"chance" : 100,
				"threshold" : 0.05,
			},
			{
				"item" : 6,
				"chance" : 100,
				"threshold" : 0.05,
			},
			{
				"item" : 7,
				"chance" : 100,
				"threshold" : 0.05,
			},
			{
				"item" : 8,
				"chance" : 100,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"rokk_the_rough" : {
		"override" : "encounter_1",
		"soulbound_loot" : [
			{
				"item" : 505,
				"chance" : 300,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"mummified_king" : {
		"override" : "encounter_1",
		"soulbound_loot" : [
			{
				"item" : 471,
				"chance" : 300,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"vigil_guardian" : {
		"override" : "encounter_1",
		"soulbound_loot" : [
			{
				"item" : 171,
				"chance" : 300,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"argolath" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 407,
				"chance" : 125,
				"threshold" : 0.05,
			},
			{
				"item" : 173,
				"chance" : 125,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"babel" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			
			{
				"item" : 145,
				"chance" : 125,
				"threshold" : 0.05,
			},
			{
				"item" : 439,
				"chance" : 50,
				"threshold" : 0.05,
			},
			{
				"item" : 15,
				"chance" : 5,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"atlas" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 171,
				"chance" : 300,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"og_the_treacherous" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 405,
				"chance" : 300,
				"threshold" : 0.1,
			},
			{
				"item" : 106,
				"chance" : 300,
				"threshold" : 0.1,
			},
		],
		"loot" : []
	},
	"eye_of_naa'zorak" : {
		"override" : "encounter_2",
		"soulbound_loot" : [
			{
				"item" : 105,
				"chance" : 400,
				"threshold" : 0.05,
			},
			{
				"item" : 438,
				"chance" : 150,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
	"salazar" : {
		"override" : "none",
		"soulbound_loot" : [],
		"loot" : []
	},
	"salazar,_rex_of_the_abyss" : {
		"override" : "encounter_2",
		"one_person_loot" : {
			"item" : 14,
			"chance" : 4,
		},
		"soulbound_loot" : [
			{
				"item" : 142,
				"chance" : 250,
				"threshold" : 0.05,
			},
			{
				"item" : 104,
				"chance" : 10,
				"threshold" : 0.05,
			},
			{
				"item" : 404,
				"chance" : 10,
				"threshold" : 0.05,
			},
			{
				"item" : 504,
				"chance" : 10,
				"threshold" : 0.05,
			}
		],
		"loot" : []
	},
	
	"pumpkin" : {
		"override" : "none",
		"soulbound_loot" : [
			{
				"item" : 13,
				"chance" : 200,
				"threshold" : 0.05,
			},
		],
		"loot" : []
	},
}

var small = 3
var medium = 4
var large = 5

var fast = 70
var med = 40
var slow = 20

var weak = 50
var mid = 120
var strong = 160

var projectile_databank = {
	"Plasma2_mid_fast" : {
		"projectile" : "Plasma2",
		"formula" : "0",
		"damage" : 120,
		"piercing" : true,
		"wait" : 0.2,
		"speed" : fast,
		"tile_range" : 10,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"PlasmaSpinner_mid_fast" : {
		"projectile" : "PlasmaSpinner",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : med,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"PlasmaSpinner_mid_mid" : {
		"projectile" : "PlasmaSpinner",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : slow,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"PlasmaBall_mid_mid" : {
		"projectile" : "PlasmaBall",
		"formula" : "0",
		"damage" : 110,
		"piercing" : true,
		"wait" : 0.2,
		"speed" : med,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"SmallPlasmaBall_mid_mid" : {
		"projectile" : "PlasmaBall",
		"formula" : "0",
		"damage" : 60,
		"piercing" : true,
		"wait" : 0.2,
		"speed" : fast,
		"tile_range" : 5,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GiantPlasmaSpinner_strong_mid" : {
		"projectile" : "GiantPlasmaSpinner",
		"formula" : "0",
		"damage" : 200,
		"piercing" : true,
		"wait" : 0.2,
		"speed" : slow,
		"tile_range" : 10,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large + 1
	},
	
	"PlatinumSlash_strong_fast" : {
		"projectile" : "PlatinumSlash",
		"formula" : "0",
		"damage" : 70,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"PlatinumSlash_mid_medium" : {
		"projectile" : "PlatinumSlash",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	
	"RockBlastSmall_mid_fast" : {
		"projectile" : "RockBlastSmall",
		"formula" : "0",
		"damage" : 20,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 3,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"RockBlastSmall_strong_medium" : {
		"projectile" : "RockBlastSmall",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : small
	},
	"RockBlast_strong_medium" : {
		"projectile" : "RockBlast",
		"formula" : "0",
		"damage" : 150,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"RockBlast_strong_fast" : {
		"projectile" : "RockBlast",
		"formula" : "0",
		"damage" : 150,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"RockBlast_mid_medium" : {
		"projectile" : "RockBlast",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	
	
	"Nature1_mid_medium" : {
		"projectile" : "Nature1",
		"formula" : "0",
		"damage" : mid,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : small
	},
	
	"GoldenArrow_weak_medium" : {
		"projectile" : "GoldenArrow",
		"formula" : "0",
		"damage" : weak,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : small
	},
	"GoldenArrow_mid_medium" : {
		"inherit" : "GoldenArrow_weak_medium",
		"damage" : mid,
	},
	"GiantBlast_slow" : {
		"projectile" : "GiantBlast",
		"formula" : "0",
		"damage" : 150,
		"piercing" : true,
		"wait" : 0,
		"speed" : 8,
		"tile_range" : 20,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : large
	},
	"GiantBlast_medium" : {
		"inherit" : "GiantBlast_slow",
		"speed" : slow,
	},
	"GiantBlast_fast" : {
		"inherit" : "GiantBlast_slow",
		"speed" : med,
	},
	"SmallBlast_strong_fast" : {
		"projectile" : "SmallBlast",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0.1,
		"speed" : fast,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : DegreesToVector(-45),
		"size" : medium
	},
	
	"GiantStack_strong_insane" : {
		"projectile" : "GiantStack",
		"formula" : "0",
		"damage" : 200,
		"piercing" : false,
		"wait" : 0,
		"speed" : 160,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : 8
	},
	"GiantStack_strong_fast" : {
		"projectile" : "GiantStack",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : large
	},
	"Stack_strong_fast" : {
		"projectile" : "Stack",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"Wave_strong_fast_short" : {
		"projectile" : "Wave",
		"formula" : "0",
		"damage" : 220,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 0.5,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"Wave_strong_fast" : {
		"projectile" : "Wave",
		"formula" : "0",
		"damage" : 120,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"Wave_mid_fast" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 70,
	},
	"Wave_weak_fast" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 30,
	},
	"Wave_strong_slow" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 120,
		"speed" : slow,
	},
	"Wave_mid_slow" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 70,
		"speed" : slow,
		"tile_range" : 6,
	},
	"Wave_weak_slow" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 30,
		"speed" : slow,
	},
	"Wave_mid_med" : {
		"inherit" : "Wave_strong_fast",
		"damage" : 60,
		"speed" : med,
	},
	
	
	
		
		"RoyalSlash_weak_medium" : {
			"projectile" : "RoyalSlash",
			"formula" : "0",
			"damage" : 50,
			"piercing" : false,
			"wait" : 0,
			"speed" : med,
			"tile_range" : 3,
			"targeter" : "nearest",
			"direction" : DegreesToVector(0),
			"size" : medium
		},
		"RoyalSlash_strong_medium" : {
			"inherit" : "RoyalSlash_weak_medium",
			"damage" : 100,
			"speed" : med,
		},
		"RoyalSlash_mid_fast" : {
			"inherit" : "RoyalSlash_weak_medium",
			"damage" : 80,
			"speed" : med,
		},
		"GiantRoyalSlash_strong_medium" : {
			"projectile" : "GiantRoyalSlash",
			"formula" : "0",
			"damage" : 200,
			"piercing" : false,
			"wait" : 0,
			"speed" : slow,
			"tile_range" : 8,
			"targeter" : "nearest",
			"direction" : DegreesToVector(0),
			"size" : large
		},
		"RoyalSlash_strong_fast_short" : {
			"inherit" : "RoyalSlash_weak_medium",
			"damage" : 100,
			"speed" : fast,
			"tile_range" : 3,
		},
		"Dart_mid_medium" : {
			"projectile" : "Dart",
			"formula" : "0",
			"damage" : 30,
			"piercing" : true,
			"wait" : 0,
			"speed" : slow,
			"tile_range" : 7,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
		"Dart_strong_medium" : {
			"inherit" : "Dart_mid_medium",
			"damage" : 120,
			"speed" : med,
		},
		"Dart_strong_medium_short" : {
			"inherit" : "Dart_mid_medium",
			"damage" : 90,
			"speed" : med,
			"tile_range" : 2,
			"size" : medium
		},
		
		"BloodShuriken1" : {
			"projectile" : "BloodShuriken",
			"formula" : "0",
			"damage" : 100,
			"piercing" : false,
			"wait" : 0,
			"speed" : slow,
			"tile_range" : 6,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
		"BloodSpinner_strong_medium" : {
			"projectile" : "BloodSpinner",
			"formula" : "0",
			"damage" : 50,
			"piercing" : false,
			"wait" : 0,
			"speed" : med,
			"tile_range" : 7,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
		"BloodSpinner_weak_fast" : {
			"inherit" : "BloodSpinner_strong_medium",
			"damage" : 30,
			"speed" : fast,
		},
		"DemonicWave_mid_fast" : {
			"projectile" : "DemonicWave",
			"formula" : "0",
			"damage" : 80,
			"piercing" : false,
			"wait" : 0,
			"speed" : fast,
			"tile_range" : 4,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
		"DemonicWave_strong_medium" : {
			"inherit" : "DemonicWave_mid_fast",
			"damage" : 120,
			"speed" : med,
			"tile_range" : 6,
		},
		"GiantDemonicBlast_strong_slow" : {
			"projectile" : "GiantDemonicBlast",
			"formula" : "0",
			"damage" : 240,
			"piercing" : false,
			"wait" : 0,
			"speed" : med,
			"tile_range" : 7,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : large
		},
		"GiantDemonicBlast_strong_fast" : {
			"inherit" : "GiantDemonicBlast_strong_slow",
			"damage" : 170,
			"speed" : fast,
			"size" : large
		},
		
		"SmallDemonicBlast_weak_fast" : {
			"projectile" : "SmallDemonicBlast",
			"formula" : "0",
			"damage" : 40,
			"piercing" : false,
			"wait" : 0,
			"speed" : fast,
			"tile_range" : 5,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : small
		},
		"SmallDemonicBlast_mid_medium" : {
			"inherit" : "SmallDemonicBlast_weak_fast",
			"damage" : 80,
			"speed" : med
		},
		"DemonicBlast_mid_slow" : {
			"projectile" : "DemonicBlast",
			"formula" : "0",
			"damage" : 100,
			"piercing" : false,
			"wait" : 0,
			"speed" : slow,
			"tile_range" : 9,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
		"DemonicBlast_strong_medium" : {
			"inherit" : "DemonicBlast_mid_slow",
			"damage" : 130,
			"speed" : med,
		},
		"DemonicBlast_strong_medium_short" : {
			"inherit" : "DemonicBlast_mid_slow",
			"damage" : 130,
			"speed" : med,
			"tile_range" : 2,
		},
		"DemonicWave_mid_fast_short" : {
			"projectile" : "DemonicWave",
			"formula" : "0",
			"damage" : 40,
			"piercing" : false,
			"wait" : 0,
			"speed" : 70,
			"tile_range" : 2,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
		"BloodSpinner_weak_fast_short" : {
			"projectile" : "BloodSpinner",
			"formula" : "0",
			"damage" : 100,
			"piercing" : false,
			"wait" : 0,
			"speed" : fast,
			"tile_range" : 2,
			"targeter" : "nearest",
			"direction" : Vector2.ZERO,
			"size" : medium
		},
	"BlueBlast_strong_fast" : {
		"projectile" : "BlueBlast",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 5,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : small
	},
	"SandBlastSmall_mid_fast" : {
		"projectile" : "SandBlastSmall",
		"formula" : "0",
		"damage" : 20,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 3,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"SandBlastSmall_strong_medium" : {
		"projectile" : "SandBlastSmall",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 3,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : small
	},
	"SandBlast_strong_medium" : {
		"projectile" : "SandBlast",
		"formula" : "0",
		"damage" : 150,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"SandBlast_strong_fast" : {
		"projectile" : "SandBlast",
		"formula" : "0",
		"damage" : 150,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"SandBlast_mid_medium" : {
		"projectile" : "SandBlast",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"IceBlast_mid_fast" : {
		"projectile" : "IceBlast",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : med,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"IceBlast_mid_mid" : {
		"projectile" : "IceBlast",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : slow,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GiantIceBlast_fast_strong" : {
		"projectile" : "GiantIceBlast",
		"formula" : "0",
		"damage" : 170,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : med,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"AbyssBlast_strong_mid" : {
		"projectile" : "AbyssBlast",
		"formula" : "0",
		"damage" : 90,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : slow,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"AbyssBlast_weak_fast" : {
		"projectile" : "AbyssBlast",
		"formula" : "0",
		"damage" : 30,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : med,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"IceSlash_weak_slow" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 40,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : 10,
		"tile_range" : 4,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"Ball_weak_fast" : {
		"projectile" : "Ball",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(-0.866,0.5),
		"size" : medium
	},
	"IceSlash_mid_fast" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 70,
		"piercing" : false,
		"wait" : 0.2,
		"speed" : med,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"IceSpinner_mid_medium" : {
		"projectile" : "IceSpinner",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 5,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"IceSpinner_strong_fast" : {
		"projectile" : "IceSpinner",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GiantIceSpinner_strong_fast" : {
		"projectile" : "GiantIceSpinner",
		"formula" : "0",
		"damage" : 150,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantIceSlash_mid_slow" : {
		"projectile" : "GiantIceSlash",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantIceSlash_strong_fast" : {
		"projectile" : "GiantIceSlash",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantIceSlash_strong_medium" : {
		"projectile" : "GiantIceSlash",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"IceSlash_strong_fast" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"IceSlash_strong_medium" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"IceSlash_weak_medium" : {
		"projectile" : "IceSlash",
		"formula" : "0",
		"damage" : 40,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"Ball_strong_slow" : {
		"projectile" : "Ball",
		"formula" : "0",
		"damage" : 80,
		"piercing" : false,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"Ball_mid_fast" : {
		"projectile" : "Ball",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GiantBall_strong_slow" : {
		"projectile" : "GiantBall",
		"formula" : "0",
		"damage" : 300,
		"piercing" : true,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantBall_mid_fast" : {
		"projectile" : "GiantBall",
		"formula" : "0",
		"damage" : 140,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantAbyssSpinner_strong_medium" : {
		"projectile" : "GiantAbyssSpinner",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantAbyssSpinner_strong_slow" : {
		"projectile" : "GiantAbyssSpinner",
		"formula" : "0",
		"damage" : 180,
		"piercing" : false,
		"wait" : 0,
		"speed" : 10,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantAbyssSpinner_mid_fast" : {
		"projectile" : "GiantAbyssSpinner",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"AbyssSpinner_mid_fast" : {
		"projectile" : "AbyssSpinner",
		"formula" : "0",
		"damage" : 60,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"AbyssSpinner_strong_medium" : {
		"projectile" : "AbyssSpinner",
		"formula" : "0",
		"damage" : 160,
		"piercing" : false,
		"wait" : 0,
		"speed" : 15,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GreenBlast_1" : {
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 4,
						"piercing" : false,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : large
					},
	"None" : {
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 0,
						"piercing" : true,
						"wait" : 1000,
						"speed" : 0,
						"tile_range" : 0,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
	},
	"FlameArrow_strong_fast_short" : {
		"projectile" : "FlameArrow",
		"formula" : "0",
		"damage" : 130,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameBurst_strong_fast" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 140,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameBurst_strong_slow" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 130,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameBurst_medium_fast" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameBurst_weak_fast" : {
		"projectile" : "FlameBurst",
		"formula" : "0",
		"damage" : 40,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GiantFlameArrow_strong_medium" : {
		"projectile" : "GiantFlameArrow",
		"formula" : "0",
		"damage" : 250,
		"piercing" : true,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantFlameArrow_strong_fast" : {
		"projectile" : "GiantFlameArrow",
		"formula" : "0",
		"damage" : 225,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"FlameArrow_strong_fast" : {
		"projectile" : "FlameArrow",
		"formula" : "0",
		"damage" : 140,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameArrow_mid_fast" : {
		"projectile" : "FlameArrow",
		"formula" : "0",
		"damage" : 80,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameBlast_strong_slow" : {
		"projectile" : "FlameBlast",
		"formula" : "0",
		"damage" : 110,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"FlameBlast_strong_fast" : {
		"projectile" : "FlameBlast",
		"formula" : "0",
		"damage" : 110,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"GiantFlameBlast_strong_fast" : {
		"projectile" : "GiantFlameBlast",
		"formula" : "0",
		"damage" : 200,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 40,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"GiantFlameBlast_strong_medium" : {
		"projectile" : "GiantFlameBlast",
		"formula" : "0",
		"damage" : 200,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"Slash_1" : {
		"projectile" : "Slash",
		"formula" : "0",
		"damage" : 2,
		"piercing" : false,
		"wait" : 3,
		"speed" : 10,
		"tile_range" : 3,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : large
	},
	"Blast_strong_fast" : {
		"projectile" : "Blast",
		"formula" : "0",
		"damage" : 120,
		"piercing" : false,
		"wait" : 0.1,
		"speed" : med,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : DegreesToVector(-5),
		"size" : medium
	},
	"VigilBlastSmall_1" : {
		"projectile" : "VigilBlastSmall",
		"formula" : "0",
		"damage" : 45,
		"piercing" : false,
		"wait" : 0,
		"speed" : 25,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"VigilBlastSmall_strong_fast" : {
		"projectile" : "VigilBlastSmall",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : Vector2.ZERO,
		"size" : medium
	},
	"VigilBlastSmall_slow" : {
		"inherit" : "VigilBlastSmall_1",
		"speed" : 15,
	},
	"VigilBlast_strong_fast" : {
		"projectile" : "VigilBlast",
		"formula" : "0",
		"damage" : 190,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"NeonArrow_mid_slow" : {
		"projectile" : "NeonArrow",
		"formula" : "0",
		"damage" : 120,
		"piercing" : true,
		"wait" : 0,
		"speed" : 60,
		"tile_range" : 10,
		"direction" : DegreesToVector(0),
		"size" : medium
	},
	"NeonArrow_mid_fast" : {
		"projectile" : "NeonArrow",
		"formula" : "0",
		"damage" : 100,
		"piercing" : true,
		"wait" : 0,
		"speed" : 70,
		"tile_range" : 10,
		"direction" : DegreesToVector(0),
		"size" : small
	},
	"NeonStar_strong_fast" : {
		"projectile" : "NeonStar",
		"formula" : "0",
		"damage" : 100,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(30),
		"size" : small
	},
	"NeonStar_mid_fast" : {
		"projectile" : "NeonStar",
		"formula" : "0",
		"damage" : 70,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(30),
		"size" : small
	},
	"NeonStar_weak_fast" : {
		"projectile" : "NeonStar",
		"formula" : "0",
		"damage" : 50,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : DegreesToVector(30),
		"size" : small
	},
	"GoldDart_strong_fast" : {
		"projectile" : "GoldDart",
		"formula" : "0",
		"damage" : 250,
		"piercing" : true,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 15,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : large
	},
	"Dart_strong_fast" : {
		"projectile" : "Dart",
		"formula" : "0",
		"damage" : 160,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : medium
	},
	"Dart_mid_fast" : {
		"projectile" : "Dart",
		"formula" : "0",
		"damage" : 80,
		"piercing" : true,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : medium
	},
	"Ring_strong_slow" : {
		"projectile" : "Ring",
		"formula" : "0",
		"damage" : 250,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 12,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : medium
	},
	"Star_strong_slow" : {
		"projectile" : "Star",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"Star_strong_medium" : {
		"projectile" : "Star",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : slow,
		"tile_range" : 6,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"Spinner_strong_medium" : {
		"projectile" : "Spinner",
		"formula" : "0",
		"damage" : 140,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 10,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"GiantSpinner_strong_medium" : {
		"projectile" : "GiantSpinner",
		"formula" : "0",
		"damage" : 300,
		"piercing" : true,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 10,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : medium
	},
	"Fire1_strong_fast" : {
		"projectile" : "Fire1",
		"formula" : "0",
		"damage" : 50,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 7,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"Fire2_strong_fast" : {
		"projectile" : "Fire2",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 8,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"Fire3_strong_fast" : {
		"projectile" : "Fire3",
		"formula" : "0",
		"damage" : 160,
		"piercing" : false,
		"wait" : 0,
		"speed" : fast,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
	"Stack_strong_medium" : {
		"projectile" : "Stack",
		"formula" : "0",
		"damage" : 100,
		"piercing" : false,
		"wait" : 0,
		"speed" : med,
		"tile_range" : 9,
		"targeter" : "nearest",
		"direction" : Vector2(0,1),
		"size" : small
	},
}

func _ready():
	ClassMap()
	
	#Achievements
	for achievement in achievements:
		var data = achievements[achievement]
		if data.which == "enemies_killed" and data.has("enemies"):
			enemies_tracked += data.enemies
	
	
	#Loot pools
	
	var high_chance = 6
	var decent_chance = 10
	var low_chance = 20
	var rare_chance = 100
	
	for item_id in items.keys():
		var item = items[item_id]
		if item.type == "Consumable":
			continue
		if item.tier == "0":
			basic_loot_pools["lowlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["lowlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
		if item.tier == "1":
			basic_loot_pools["midlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["midlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
			basic_loot_pools["highlands_1"].loot.append({
				"item" : item_id,
				"chance" : low_chance,
			})
			basic_loot_pools["highlands_2"].loot.append({
				"item" : item_id,
				"chance" : high_chance,
			})
		if item.tier == "2":
			basic_loot_pools["highlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.2,
			})
			basic_loot_pools["highlands_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.2,
			})
			basic_loot_pools["godlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.2,
			})
		if item.tier == "3":
			basic_loot_pools["godlands_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.5,
			})
			basic_loot_pools["ruler_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : low_chance,
				"threshold" : 0.01,
			})
			basic_loot_pools["encounter_1"].soulbound_loot.append({
				"item" : item_id,
				"chance" : low_chance,
				"threshold" : 0.01,
			})
			basic_loot_pools["encounter_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : decent_chance,
				"threshold" : 0.01,
			})
		if item.tier == "4":
			basic_loot_pools["encounter_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : rare_chance,
				"threshold" : 0.01,
			})
			basic_loot_pools["encounter_2"].soulbound_loot.append({
				"item" : item_id,
				"chance" : low_chance,
				"threshold" : 0.2,
			})
	
	for enemy_name in special_loot_pools.keys():
		var pool = special_loot_pools[enemy_name]
		pool.soulbound_loot += basic_loot_pools[pool.override].soulbound_loot
		pool.loot += basic_loot_pools[pool.override].loot

var databank_configured = false
func ConfigureProjectileDatabank():
	databank_configured = true
	for projectile_type in projectile_databank.keys():
		var projectile = projectile_databank[projectile_type]
		
		if projectile.has("inherit"):
			projectile.merge(projectile_databank[projectile.inherit])

func MakeProjectile(projectile_type, degrees, wait, targeter = null):
	if not databank_configured:
		ConfigureProjectileDatabank()
	
	var angle = DegreesToVector(degrees)
	var projectile_data = projectile_databank[projectile_type].duplicate()
	
	projectile_data.direction = angle
	projectile_data.wait = wait
	if targeter:
		projectile_data.targeter = targeter
	elif projectile_data.has("targeter"):
		projectile_data.erase("targeter")
	
	return projectile_data

func CreateArc(steps, from, to, projectile, targeter = null):
	var attack_pattern = []
	var offset = steps/4 if targeter else 0
	for step in to-from:
		attack_pattern.append(MakeProjectile(projectile, (360.0/steps)*(step+from-offset), 0, targeter))
	return attack_pattern


func CreateSpiral(arm_count, projectile_type, delay, mix_in = null, chance = 0.2, steps = 32.0, invincible = false, reverse = false):
	randomize()
	var attack_pattern = []
	var coefficient = -1 if reverse else 1
	
	for step in steps:
		if invincible:
			attack_pattern.append({
				"effect" : "invincible",
				"duration" : 1,
				"wait" : 0,
			})
		if mix_in and randf() < chance:
			var projectile = MakeProjectile(mix_in, randi() % 360, 0)
			attack_pattern.append(projectile)
		for arm in range(arm_count):
			var wait = delay if (arm+1 == arm_count) else 0
			var projectile = MakeProjectile(projectile_type, coefficient*(360.0/steps)*(step+arm*(steps/arm_count)), wait)
			attack_pattern.append(projectile)
	
	return attack_pattern

var misc =  {
	"oracle_placeholder" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(1000,1000), Vector2(1,1)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"no_sink" : true,
		"health_scaling" : 0,
		"health" : 1,
		"defense" : 0,
		"exp" : 0,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 13,
				"behavior" : 0,
				"speed" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [-100,0],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_passive",
						"summon_position" : Vector2(3*8,0),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_passive",
						"summon_position" : Vector2(-3*8,0),
						"wait" : OS.get_system_time_msecs(),
					},
				]
			},
		]
	}, 
	"nature_sprite_passive" : {
		"custom_hitbox" : Vector2(0,0),
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(120,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,1],
		},
		
		"health" : 40,
		"defense" : 0,
		"exp" : 5,
		"behavior" : 3,
		"anchor" : "parent",
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 100,
						"wait" : 10,
					},
				]
			}
		]
	},
}
var rulers = {
	"oracle" : {
		"scale" : 1,
		"res" : 38,
		"height" : 20,
		"rect" : Rect2(Vector2(114,38), Vector2(114,38)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,0],
		},
		
		"health_scaling" : 10000,
		"health" : 60000,
		"defense" : 10,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "tower_of_babel_floor_1"
		},
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 40,
				"behavior" : 0,
				"speed" : 0,
				"on_signal" : ["pillars_active"],
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"speech" : "As long as my 3 pillars stand, I am impervious!",
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 4,
					},
					{
						"speech" : "Search all you want, my 3 pillars will never fall!",
						"wait" : 0,
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "oracle_pillar",
						"summon_position" : DegreesToVector((360.0/3.0)*1)*8*30,
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "oracle_pillar",
						"summon_position" : DegreesToVector((360.0/3.0)*2)*8*30,
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "oracle_pillar",
						"summon_position" : DegreesToVector((360.0/3.0)*3)*8*30,
						"flip" : 0,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"speech" : "I forsaw your downfall in a dream!",
						"wait" : 1,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [50,100],
				"attack_pattern" : CreateArc(32, 1, 16, "SmallPlasmaBall_mid_mid") + [
						{
							"wait" : 0.5
						}
					] + CreateArc(32, 1, 16, "PlasmaBall_mid_mid") + [
						{
							"wait" : 0
						}
					] + CreateArc(24, 1, 12, "PlasmaSpinner_mid_mid") + [
						{
							"wait" : 0.5
						}
					] + CreateArc(16, 1, 8, "PlasmaSpinner_mid_mid") + [
						{
							"wait" : 1
						}
					] + CreateArc(32, 17, 32, "SmallPlasmaBall_mid_mid") + [
						{
							"wait" : 0.5
						}
					] + CreateArc(32, 17, 32, "PlasmaBall_mid_mid") + [
						{
							"wait" : 0
						}
					] + CreateArc(24, 13, 24, "PlasmaSpinner_mid_mid") + [
						{
							"wait" : 0.5
						}
					] + CreateArc(16, 9, 16, "PlasmaSpinner_mid_mid") + [
						{
							"wait" : 2
						}
					] + CreateSpiral(1, "GiantPlasmaSpinner_strong_mid", 0, null, 0, 7) + [{
						"wait" : 1
					}
				]
			},
			{
				"duration" : 5,
				"health" : [50,100],
				"attack_pattern" : CreateSpiral(1, "GiantPlasmaSpinner_strong_mid", 0.1, null, 0, 16) + [{
						"wait" : 1
					}] + CreateSpiral(1, "GiantPlasmaSpinner_strong_mid", 0.1, null, 0, 17) + [{
						"wait" : 1
					}] + CreateSpiral(1, "GiantPlasmaSpinner_strong_mid", 0.1, null, 0, 18) + [{
						"wait" : 1
					}] + CreateSpiral(1, "Plasma2_mid_fast", 0.1, null, 0, 8) + [{
						"wait" : 0.4
					}] + CreateSpiral(1, "Plasma2_mid_fast", 0.1, null, 0, 8) + [{
						"wait" : 0.4
					}] + CreateSpiral(1, "Plasma2_mid_fast", 0.1, null, 0, 8) + [{
						"wait" : 0.4
					}]
			},
			{
				"duration" : 3.5,
				"health" : [50,100],
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 3.5,
						"wait" : 0,
					},
					{
						"speech" : "The world of man will crumble!",
						"wait" : 0,
					},
					{
						"summon" : "oracle_pillar_summon",
						"summon_position" : DegreesToVector((360.0/4.0)*1)*8*10,
						"flip" : 0,
						"wait" : 1,
					},
					{
						"summon" : "oracle_pillar_summon",
						"summon_position" : DegreesToVector((360.0/4.0)*2)*8*10,
						"flip" : 0,
						"wait" : 1,
					},
					{
						"summon" : "oracle_pillar_summon",
						"summon_position" : DegreesToVector((360.0/4.0)*3)*8*10,
						"flip" : 0,
						"wait" : 1,
					},
					{
						"summon" : "oracle_pillar_summon",
						"summon_position" : DegreesToVector((360.0/4.0)*4)*8*10,
						"flip" : 0,
						"wait" : 1,
					},
				]
			},
			
			{
				"duration" : 3.5,
				"health" : [0,50],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 3.5,
						"wait" : 0,
					},
					{
						"speech" : "I have seen thousands of kingdoms fall...",
						"wait" : 0,
					},
					{
						"speech" : "Babel alone has withstood the turmoil!",
						"wait" : 2,
					},
					{
						"summon" : "bookish_novel",
						"summon_position" : DegreesToVector((360.0/4.0)*1)*8*12,
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "bookish_novel",
						"summon_position" : DegreesToVector((360.0/4.0)*2)*8*12,
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "bookish_novel",
						"summon_position" : DegreesToVector((360.0/4.0)*3)*8*12,
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "bookish_novel",
						"summon_position" : DegreesToVector((360.0/4.0)*4)*8*12,
						"flip" : 0,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,50],
				"attack_pattern" : [
					MakeProjectile("SmallPlasmaBall_mid_mid", 15, 0, "nearest"),
					MakeProjectile("PlasmaBall_mid_mid", 10, 0, "nearest"),
					MakeProjectile("SmallPlasmaBall_mid_mid", 5, 0, "nearest"),
					MakeProjectile("PlasmaBall_mid_mid", 0, 0, "nearest"),
					MakeProjectile("SmallPlasmaBall_mid_mid", -5, 0, "nearest"),
					MakeProjectile("PlasmaBall_mid_mid", -10, 0, "nearest"),
					MakeProjectile("SmallPlasmaBall_mid_mid", -15, 0.5, "nearest"),
				]
			},
		]
	},
	"bookish_novel" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,144), Vector2(36,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		
		"no_sink" : true,
		"health" : 1000,
		"defense" : 0,
		"exp" : 100,
		"anchor" : "parent",
		"behavior" : 3,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					MakeProjectile("Wave_mid_med", 15, 0, "parent"),
					MakeProjectile("Wave_mid_med", 5, 0, "parent"),
					MakeProjectile("Wave_mid_med", -5, 0, "parent"),
					MakeProjectile("Wave_mid_med", -15, 0.5, "parent"),
					MakeProjectile("Wave_mid_slow", 15, 0, "parent"),
					MakeProjectile("Wave_mid_slow", 5, 0, "parent"),
					MakeProjectile("Wave_mid_slow", -5, 0, "parent"),
					MakeProjectile("Wave_mid_slow", -15, 0.5, "parent"),
				]
			},
		]
	},
	"oracle_pillar_summon" : {
		"scale" : 1.4,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(36,144), Vector2(18*3,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
			"Death" : [2],
		},
		
		"health" : 500,
		"defense" : 1000,
		"exp" : 500,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Plasma1",
						"formula" : "0",
						"damage" : 50,
						"piercing" :true,
						"wait" : 0.2,
						"speed" : fast,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : Vector2.ZERO,
						"size" : 4
					},
				]
			},
		]
	},
	"oracle_pillar" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(36,144), Vector2(18*3,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
			"Death" : [2],
		},
		
		"health" : 20000,
		"defense" : 1,
		"exp" : 500,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Plasma1",
						"formula" : "0",
						"damage" : 5,
						"piercing" :true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 30,
						"targeter" : "parent",
						"direction" : Vector2.ZERO,
						"size" : 4
					},
					{
						"signal" : "pillars_active",
						"reciever" : "oracle",
						"duration" : 1.1,
						"wait" : 0.3,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 4
					},
				]
			}
		]
	},
	
	"oranix" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,54), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health_scaling" : 10000,
		"health" : 30000,
		"defense" : 10,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "orc_vigil"
		},
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 13,
				"behavior" : 0,
				"speed" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [-100,1],
				"attack_pattern" : [
					{
						"speech" : "No matter, the vigil shall bring you to ruin!",
						"wait" : 3,
					},
					{
						"speech" : "No matter, the vigil shall bring you to ruin!",
						"wait" : 10,
					},
				]
			},
			{
				"duration" : 12,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"health" : [99.9999999,100],
				"attack_pattern" : [
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("Wave_mid_slow", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 6,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "I stand guard over the last remanants of the great orc kingdom...",
						"wait" : 3,
					},
					{
						"speech" : "As a vessel of Salazar I will not fall!",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : CreateSpiral(2, "GoldDart_strong_fast", 0.2,  "Wave_mid_slow", 0.5)
			},
			{
				"duration" : 4,
				"health" : [25,100],
				"behavior" : 1,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("GoldDart_strong_fast", (360.0/8.0)*8, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 30, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 20, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 10, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", -10, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", -20, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", -30, 2, "nearest"),
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 1,
				"speed" : 10,
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(30),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-30),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 150,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : medium
					},
					MakeProjectile("Wave_mid_slow", 300, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 180, 0, "nearest"),
					MakeProjectile("Wave_mid_slow", 60, 2, "nearest"),
				]
			},
			{
				"duration" : 6,
				"health" : [25,100],
				"behavior" : 2,
				"speed" : 12,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_fast", 0, 0.2, "nearest"),
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 150,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : medium
					},
				]
			},
			{
				"duration" : 12,
				"health" : [0,25],
				"on_spawn" : true,
				"behavior" : 2,
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : fast,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 200,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : fast,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.1,
						"speed" : fast,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 100,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 14,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : medium
					},
				]
			}
		]
	},
	"vajira" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,72), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health_scaling" : 10000,
		"health" : 30000,
		"defense" : 10,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 0,
			"name" : "frozen_fortress"
		},
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 13,
				"behavior" : 0,
				"speed" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [-100,0],
				"attack_pattern" : [
					{
						"speech" : "Make sure that monster dosen't escape! He is your burden now.",
						"wait" : 3,
					},
					{
						"speech" : "Make sure that monster dosen't escape! He is your burden now.",
						"wait" : 10,
					},
				]
			},
			{
				"duration" : 12,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"health" : [99.9999999,100],
				"attack_pattern" : [
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "I have been entrusted to guard this fortress with my life...",
						"wait" : 3,
					},
					{
						"speech" : "The creature inside is more powerful then you know. Challenge me if you dare!",
						"wait" : 3,
					},
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*1, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*2, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*3, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*4, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*5, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*6, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*7, 0),
					MakeProjectile("GiantBall_strong_slow", (360.0/8.0)*8, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("Ball_strong_slow", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 6,
				"behavior" : 2,
				"speed" : 15,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("GiantIceSlash_strong_medium", 0, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_medium", 20, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_medium", -20, 0.5, "nearest"),
					
					MakeProjectile("IceSlash_strong_fast", 0, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 20, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", -20, 0.5, "nearest"),
					
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*1), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*2), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*3), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*4), 0),
					MakeProjectile("Ball_strong_slow", 36+((360.0/5)*5), 0.2),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*1), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*2), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*3), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*4), 0),
					MakeProjectile("Ball_mid_fast", 0+((360.0/5)*5), 0.2),
				]
			},
			{
				"duration" : 6,
				"behavior" : 0,
				"speed" : 10,
				"health" : [25,100],
				"attack_pattern" : CreateSpiral(3, "Ball_strong_slow", 0.4, "IceSlash_strong_medium", 0.3)
			},
			{
				"duration" : 6,
				"behavior" : 1,
				"speed" : 10,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("GiantIceSlash_mid_slow", 60+((360.0/3.0)*1), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 60+((360.0/3.0)*2), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 60+((360.0/3.0)*3), 0.5),
					
					MakeProjectile("IceSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_medium", 10, 0, "nearest"),
					MakeProjectile("IceSlash_strong_medium", -10, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_medium", -20, 0, "nearest"),
					MakeProjectile("IceSlash_strong_medium", 20, 0.2, "nearest"),
					
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*1, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*2, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*3, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*4, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*5, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*6, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*7, 0),
					MakeProjectile("Ball_mid_fast", (360.0/8.0)*8, 0.5),
					
					MakeProjectile("GiantIceSlash_mid_slow", 0+((360.0/3.0)*1), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 0+((360.0/3.0)*2), 0),
					MakeProjectile("GiantIceSlash_mid_slow", 0+((360.0/3.0)*3), 0.5),
				]
			},
			{
				"duration" : 6,
				"behavior" : 2,
				"speed" : 5,
				"health" : [0,25],
				"attack_pattern" : [
					MakeProjectile("GiantBall_mid_fast", 60+((360.0/3.0)*1), 0),
					MakeProjectile("GiantBall_mid_fast", 60+((360.0/3.0)*2), 0),
					MakeProjectile("GiantBall_mid_fast", 60+((360.0/3.0)*3), 0.5),
					
					MakeProjectile("IceSlash_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_fast", -20, 0, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 20, 0.2, "nearest"),
					
					MakeProjectile("GiantIceSlash_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", -20, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", 20, 0.2, "nearest"),
					
					MakeProjectile("Ball_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("Ball_mid_fast", 10, 0, "nearest"),
					MakeProjectile("Ball_mid_fast", -10, 0.2, "nearest"),
					MakeProjectile("Ball_mid_fast", -20, 0, "nearest"),
					MakeProjectile("Ball_mid_fast", 20, 0.2, "nearest"),
					
					MakeProjectile("GiantBall_strong_slow", 0+((360.0/3.0)*1), 0),
					MakeProjectile("GiantBall_strong_slow", 0+((360.0/3.0)*2), 0),
					MakeProjectile("GiantBall_strong_slow", 0+((360.0/3.0)*3), 0.5),
				]
			},
		]
	},
	"raa'sloth" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,90), Vector2(90,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health_scaling" : 10000,
		"health" : 30000,
		"defense" : 20,
		"exp" : 2000,
		"behavior" : 1,
		"speed" : 4,
		"dungeon" : {
			"rate" : 0,
			"name" : "ruined_temple"
		},
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 13,
				"behavior" : 0,
				"speed" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [-100,0],
				"attack_pattern" : [
					{
						"speech" : "I am merely a pawn, Naa'zorak shall char your bones!",
						"wait" : 3,
					},
					{
						"speech" : "I am merely a pawn, Naa'zorak shall char your bones!",
						"wait" : 10,
					},
				]
			},
			{
				"duration" : 12,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"health" : [99.9999999,100],
				"attack_pattern" : [
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*1, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*2, 0),
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*3, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*4, 0),
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*5, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*6, 0),
					MakeProjectile("AbyssSpinner_mid_fast", (45.0/2)+(360.0/8.0)*7, 0),
					MakeProjectile("RoyalSlash_mid_fast", (45.0/2)+(360.0/8.0)*8, 2),
				]
			},
			{
				"duration" : 5,
				"behavior" : 1,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					{
						"speech" : "I have been entrusted to rule over this island as a vessel...",
						"wait" : 3,
					},
					{
						"speech" : "Salazar will not fall to the likes of you!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 5,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", (360.0/8.0)*8, 0, "nearest"),
					
					MakeProjectile("GiantAbyssSpinner_mid_fast", 0, 0.2, "nearest"),
					
					MakeProjectile("GiantAbyssSpinner_mid_fast", 45, 0, "nearest"),
					MakeProjectile("GiantAbyssSpinner_mid_fast", -45, 0.2, "nearest"),
					
					MakeProjectile("RoyalSlash_mid_fast", 0, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", -10, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 10, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", -20, 0, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 20, 0.5, "nearest"),
				]
			},
			{
				"duration" : 6,
				"behavior" : 0,
				"speed" : 5,
				"health" : [25,100],
				"attack_pattern" : CreateSpiral(2, "AbyssSpinner_mid_fast", 0.2, "GiantRoyalSlash_strong_medium", 1)
			},
			{
				"duration" : 6,
				"behavior" : 2,
				"speed" : 10,
				"health" : [25,100],
				"attack_pattern" : [
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*1), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*2), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*3), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*4), 0),
					MakeProjectile("AbyssSpinner_mid_fast", 36+((360.0/5.0)*5), 0),
					
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*1), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*2), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*3), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*4), 0),
					MakeProjectile("AbyssSpinner_mid_fast", ((360.0/5.0)*5), 0),
					
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", 0, 0.2, "nearest"),
				]
			},
			{
				"duration" : 60,
				"behavior" : 1,
				"speed" : 5,
				"health" : [0,25],
				"attack_pattern" : CreateSpiral(1, "RoyalSlash_mid_fast", 0.1, "GiantAbyssSpinner_strong_medium", 0.3) + [
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*1), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*2), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*3), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*4), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*5), 0),
					
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*1), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*2), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*3), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*4), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*5), 1),
					
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*1), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*2), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*3), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*4), 0),
					MakeProjectile("GiantRoyalSlash_strong_medium", 36+((360.0/5.0)*5), 0),
					
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*1), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*2), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*3), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*4), 0),
					MakeProjectile("RoyalSlash_strong_medium", ((360.0/5.0)*5), 1),
				]
			},
		]
	},
	"salazar" : {
		"scale" : 1.3,
		"res" : 38,
		"height" : 20,
		"rect" : Rect2(Vector2(0,38), Vector2(114,38)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
			"Death" : [2],
		},
		
		"no_sink" : true,
		"health_scaling" : 40000,
		"health" : 10000,
		"defense" : 10,
		"exp" : 10000,
		"behavior" : 0,
		"speed" : 10,
		"dungeon" : {
			"rate" : 1,
			"name" : "the_abyss"
		},
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 13,
				"behavior" : 0,
				"speed" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [-100,0],
				"attack_pattern" : [
					{
						"speech" : "Meet your fate in the abyss!",
						"wait" : 3,
					},
					{
						"speech" : "Meet your fate in the abyss!",
						"wait" : 10,
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "salazar_wing",
						"summon_position" : Vector2(-19,-1),
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "salazar_wing",
						"summon_position" : Vector2(20,-1),
						"flip" : 1,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [99.99,100],
				"attack_pattern" : [
					{
						"wait" : OS.get_system_time_secs(),
					},
				]
			},
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,99.99],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "So all my vessels have fallen...",
						"wait" : 3,
					},
					{
						"speech" : "You are not to be underestimated. The abyss awaits you!",
						"wait" : 3,
					},
					#{
						#"summon" : "fireball",
						#"summon_position" : Vector2(8*5,0),
						#"wait" : 0,
					#},
					#{
						#"summon" : "fireball",
						#"summon_position" : Vector2(-8*5,0),
						#"wait" : 0,
					#},
				]
			},
			{
				"duration" : 5,
				"health" : [75,99.99],
				"attack_pattern" : [
					MakeProjectile("FlameBlast_strong_fast", -30, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -20, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 30, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 2, "nearest"),
				]
			},
			{
				"duration" : 5,
				"health" : [75,99.99],
				"attack_pattern" : CreateSpiral(4, "FlameBurst_weak_fast", 0.2)
			},
			{
				"duration" : 7,
				"health" : [25,75],
				"attack_pattern" : [
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*1, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*2, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*3, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*4, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*5, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*6, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*7, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8.0)*8, 1),
					MakeProjectile("GiantFlameArrow_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.1, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.1, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.1, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.8, "nearest"),
					
					MakeProjectile("FlameArrow_mid_fast", (360.0/5.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/5.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/5.0)*3, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/5.0)*4, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/5.0)*5, 0.8),
				]
			},
			{
				"duration" : 5,
				"health" : [25,75],
				"attack_pattern" : [
					MakeProjectile("Fire1_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("Fire2_strong_fast", -25, 0.1, "nearest"),
					MakeProjectile("Fire3_strong_fast", 15, 0.1, "nearest"),
					MakeProjectile("Fire2_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("Fire1_strong_fast", 25, 0.1, "nearest"),
					MakeProjectile("Fire1_strong_fast", 1, 0.1, "nearest"),
					MakeProjectile("Fire2_strong_fast", 10, 0.1, "nearest"),
					MakeProjectile("Fire3_strong_fast", -15, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/5.0)*1, 0),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/5.0)*2, 0),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/5.0)*3, 0),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/5.0)*4, 0),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/5.0)*5, 1),
				]
			},
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,25],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "PUNY MORTALS...!",
						"wait" : 3,
					},
					{
						"speech" : "FEAR THE ABYSS!",
						"wait" : 0,
					},
					#{
						#"summon" : "fireball",
						#"summon_position" : Vector2(8*5,0),
						#"wait" : 0,
					#},
					#{
						#"summon" : "fireball",
						#"summon_position" : Vector2(-8*5,0),
						#"wait" : 3,
					#},
				]
			},
			{
				"duration" : 25,
				"health" : [0,25],
				"attack_pattern" : CreateSpiral(1, "FlameBurst_strong_slow", 0.1) + [
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*1, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*2, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*3, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*4, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*5, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*6, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*7, 0, "nearest"),
					MakeProjectile("FlameArrow_mid_fast", (360.0/8)*8, 1, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_fast", -15, 0.1, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_fast", 15, 0.1, "nearest"),
					MakeProjectile("Fire1_strong_fast", -30, 0, "nearest"),
					MakeProjectile("Fire2_strong_fast", -20, 0, "nearest"),
					MakeProjectile("Fire2_strong_fast", -10, 0, "nearest"),
					MakeProjectile("Fire3_strong_fast", 0, 0, "nearest"),
					MakeProjectile("Fire2_strong_fast", 30, 0, "nearest"),
					MakeProjectile("Fire2_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Fire1_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.2, "nearest"),
					MakeProjectile("FlameArrow_strong_fast_short", 0, 0.2, "nearest"),
				]
			},
		]
	},
	"salazar_wing" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(162,52), Vector2(36,18)),
		"custom_hitbox" : Vector2(0,0),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"no_sink" : true,
		"health" : 5000,
		"defense" : 5,
		"exp" : 3000,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 10,
					}
				]
			},
		]
	},
}
var tutorial_enemies = {
	"tutorial_crab" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 7,
		"rect" : Rect2(Vector2(0,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 20,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : [
				{
					"item" : 400,
					"chance" : 1,
				},
			]
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"attack_pattern" : [
					{"wait" : 10}
				]
			},
		]
	},
	"tutorial_nature_druid" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(140,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		"dungeon" : {
			"rate" : 1,
			"name" : "tutorial"
		},
		
		"health" : 300,
		"defense" : 3,
		"exp" : 33,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : [
				{
					"item" : 136,
					"chance" : 1,
				},
			]
		},
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 3,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					MakeProjectile("GreenBlast_1", (360.0/8)*1, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*2, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*3, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*4, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*5, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*6, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*7, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*8, 0, "nearest"),
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 2,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 1,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : medium
					}
				]
			},
		]
	},
	"tutorial_troll_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 70,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Slash_1", 0, 0.5),
					MakeProjectile("Slash_1", 90, 0.5),
					MakeProjectile("Slash_1", 180, 0.5),
					MakeProjectile("Slash_1", 270, 0.5),
				]
			}
		]
	},
	"tutorial_troll_king" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,0), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 300,
		"defense" : 2,
		"exp" : 30,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  {
			"soulbound_loot" : [
				{
					"item" : -2,
					"chance" : 1,
					"threshold" : 0.2,
				},
				{
					"item" : 166,
					"chance" : 1,
					"threshold" : 0.2,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [75,100],
				"attack_pattern" : [
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : 4
					}
				]
			},
			{
				"duration" : 4,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,75],
				"attack_pattern" : [
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(0,0),
						"wait" : 6,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,75],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
				]
			}
		]
	},
}
var realm_enemies = {
	"whitebag_crab" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 7,
		"rect" : Rect2(Vector2(0,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Slash_1", 0, 1, "nearest"),
				]
			}
		]
	},
	"crab" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 7,
		"rect" : Rect2(Vector2(0,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" :  [
					MakeProjectile("Slash_1", 0, 1, "nearest"),
				]
			}
		]
	},
	"slime" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 5,
		"rect" : Rect2(Vector2(20,0), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 50,
		"defense" : 1,
		"exp" : 10,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("GreenBlast_1", 10, 0, "nearest"),
					MakeProjectile("GreenBlast_1", -10, 3, "nearest"),
				]
			}
		]
	},
	"nature_druid" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(140,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 300,
		"defense" : 3,
		"exp" : 33,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["lowlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite_stationary",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 3,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					MakeProjectile("GreenBlast_1", (360.0/8)*1, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*2, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*3, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*4, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*5, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*6, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*7, 0, "nearest"),
					MakeProjectile("GreenBlast_1", (360.0/8)*8, 0, "nearest"),
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "nature_sprite",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 2,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Nature2",
						"formula" : "sin(x)",
						"damage" : 7,
						"piercing" : false,
						"wait" : 1,
						"speed" : slow,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : medium
					}
				]
			},
		]
	},
	"nature_sprite_stationary" : {
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(120,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 40,
		"defense" : 0,
		"exp" : 5,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature1",
						"formula" : "0",
						"damage" : 3,
						"piercing" : false,
						"wait" : 3,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					}
				]
			}
		]
	},
	"nature_sprite" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(120,10), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"variations" : ["nature_sprite_stationary"],
		"health" : 10,
		"defense" : 0,
		"exp" : 5,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Nature1",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					}
				]
			}
		]
	},
	"goblin_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,10), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 60,
		"defense" : 3,
		"exp" : 10,
		"behavior" : 2,
		"speed" : 15,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					}
				]
			}
		]
	},
	"goblin_archer" : {
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(40,10), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 30,
		"defense" : 0,
		"exp" : 5,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["lowlands_1"],
		"phases" : [
			{
				"duration" : 12,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "SteelArrow",
						"formula" : "0",
						"damage" : 4,
						"piercing" : true,
						"wait" : 6,
						"speed" : slow,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					}
				]
			}
		]
	},
	"goblin_cannon" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(80,10), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 20,
		"defense" : 1000,
		"exp" : 35,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 172,
					"chance" : 1000,
					"threshold" : 0.5,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,-10),
						"wait" : 0,
					},
					{
						"summon" : "goblin_archer",
						"summon_position" : Vector2(0,10),
						"wait" : 0,
					},
					{
						"summon" : "goblin_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 7,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "CannonBall",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 7,
						"speed" : 12,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : small
					}
				]
			},
		]
	},
	"blue_slime" : {
		"scale" : 1.5,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(80,20), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 700,
		"defense" : 1,
		"exp" : 45,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "slime",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "slime",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 3
					},
					{
						"projectile" : "Water1",
						"formula" : "0",
						"damage" : 5,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 7,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 3
					}
				]
			}
		]
	},
	"cyclops_underling" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(100,20), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 50,
		"defense" : 0,
		"exp" : 13,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 3,
						"speed" : slow,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
				]
			}
		]
	},
	"cyclops_leader" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 15,
		"rect" : Rect2(Vector2(144,0), Vector2(36,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "rocky_cave"
		},
		"health" : 300,
		"defense" : 5,
		"exp" : 50,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "cyclops_underling",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "cyclops_underling",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 15,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 4
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : med,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 4
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 7,
						"direction" : Vector2(0,1),
						"size" : medium
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 7,
						"direction" : Vector2(0.866,0.5),
						"size" : medium
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 7,
						"direction" : Vector2(0.866,-0.5),
						"size" : medium
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 7,
						"direction" : Vector2(0,-1),
						"size" : medium
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 7,
						"direction" : Vector2(-0.866,-0.5),
						"size" : medium
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 7,
						"direction" : Vector2(-0.866,0.5),
						"size" : medium
					},
				]
			}
		]
	},
	"imp_warrior" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(130,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 200,
		"defense" : 5,
		"exp" : 35,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "imp_archer",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "imp_mage",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : med,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 2,
						"speed" : slow,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
				]
			}
		]
	},
	"imp_archer" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(200,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 100,
		"defense" : 0,
		"exp" : 11,
		"behavior" : 2,
		"speed" : 8,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : 4
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 30,
						"piercing" : true,
						"wait" : 6,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : 4
					},
				]
			}
		]
	},
	"imp_mage" : {
		"scale" : 0.8,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(170,20), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 100,
		"defense" : 0,
		"exp" : 11,
		"behavior" : 2,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : 4
					},
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : 4
					},
				]
			}
		]
	},
	"fire_druid" : {
		"scale" : 0.9,
		"res" : 18,
		"height" : 8,
		"rect" : Rect2(Vector2(180,0), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "rocky_cave"
		},
		"health" : 200,
		"defense" : 0,
		"exp" : 34,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 12,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 24,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 24,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : medium
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 32,
						"piercing" : false,
						"wait" : 6,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
				]
			}
		]
	},
	"troll_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 100,
		"defense" : 1,
		"exp" : 6,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" :  basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(1,0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(0,-1),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 3,
						"direction" : Vector2(-1,0),
						"size" : 4
					}
				]
			}
		]
	},
	"troll_brute" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(40,20), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 200,
		"defense" : 5,
		"exp" : 12,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" :  basic_loot_pools["midlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : small
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : small
					}
				]
			}
		]
	},
	"troll_king" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,0), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "rocky_cave"
		},
		"health" : 300,
		"defense" : 5,
		"exp" : 45,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" :  basic_loot_pools["midlands_2"],
		"phases" : [
			{
				"duration" : 6,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 50,
						"piercing" : true,
						"wait" : 0,
						"speed" : 5,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : medium
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : small
					},
					{
						"projectile" : "Stack",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 5,
						"speed" : 10,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : Vector2(0,0),
						"size" : small
					}
				]
			},
			{
				"duration" : 4,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_warrior",
						"summon_position" : Vector2(10,0),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_brute",
						"summon_position" : Vector2(0,-10),
						"wait" : 0.2,
					},
					{
						"summon" : "troll_brute",
						"summon_position" : Vector2(0,10),
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(1,0),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 1,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(-1,0),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 0,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,1),
						"size" : 20
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : 10,
						"tile_range" : 8,
						"direction" : Vector2(0,-1),
						"size" : 20
					},
				]
			}
		]
	},
	"rat_warrior" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,30), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 100,
		"defense" : 21,
		"exp" : 3,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" :  basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : medium
					},
					{
						"projectile" : "IronSlash",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 2.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : medium
					},
				]
			}
		]
	},
	"rat_mage" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(40,30), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 250,
		"defense" : 0,
		"exp" : 5,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : small
					},
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 25,
						"piercing" : false,
						"wait" : 2,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : small
					},
					{
						"projectile" : "BrownBlast",
						"formula" : "0",
						"damage" : 10,
						"piercing" : false,
						"wait" : 2,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : small
					},
				]
			}
		]
	},
	"rat_king" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(60,30), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,2],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "desert_catacombs"
		},
		"health" : 900,
		"defense" : 9,
		"exp" : 65,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "rat_warrior",
						"summon_position" : Vector2(-10,0),
						"wait" : 0.1,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,10),
						"wait" : 0.1,
					},
					{
						"summon" : "rat_mage",
						"summon_position" : Vector2(0,-10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : medium
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : medium
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : medium
					},
					{
						"projectile" : "GoldSlash",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 2.5,
						"speed" : med,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : medium
					},
				]
			}
		]
	},
	"viking_king" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(72,0), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "desert_catacombs"
		},
		"health" : 1800,
		"defense" : 6,
		"exp" : 95,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 2,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(-10,-5),
						"wait" : 0.1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(10,-5),
						"wait" : 0.1,
					},
					{
						"summon" : "viking_warrior",
						"summon_position" : Vector2(0,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0,1),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0.707,0.707),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(1,0),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0.707,-0.707),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(0,-1),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,-0.707),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-1,0),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 2,
						"speed" : 44,
						"tile_range" : 6,
						"direction" : Vector2(-0.707,0.707),
						"size" : medium
					},
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-17),
						"size" : medium
					},
					{
						"projectile" : "Spinner",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(17),
						"size" : medium
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : small
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : small
					},
					{
						"projectile" : "Dart",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : 25,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : small
					},
				]
			},
		]
	},
	"viking_warrior" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(90,30), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,2],
		},
		
		"health" : 190,
		"defense" : 0,
		"exp" : 20,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : slow,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : slow,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
					{
						"projectile" : "Slash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 3,
						"speed" : slow,
						"tile_range" : 2,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : 4
					},
				]
			}
		]
	},
	"yellow_slime" : {
		"scale" : 1.6,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(130,30), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 2000,
		"defense" : 0,
		"exp" : 80,
		"behavior" : 1,
		"speed" : 8,
		"loot_pool" : basic_loot_pools["highlands_2"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.5,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "blue_slime",
						"summon_position" : Vector2(10,10),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "Fire3",
						"formula" : "0",
						"damage" : 40,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 30,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "Fire1",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.25,
						"speed" : 25,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					},
				]
			},
		]
	},
	"shadow_druid" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(150,30), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 600,
		"defense" : 5,
		"exp" : 200,
		"behavior" : 1,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 144,
					"chance" : 500,
					"threshold" : 0.5,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "skeletal_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"summon" : "skeletal_warrior",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "skeletal_archer",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [50,100],
				"attack_pattern" : [
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 70,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 3,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : medium
					},
				]
			},
			{
				"duration" : 3,
				"health" : [0,50],
				"attack_pattern" : [
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 0,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : medium
					},
					{
						"projectile" : "Ball",
						"formula" : "0",
						"damage" : 35,
						"piercing" : true,
						"wait" : 1,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-35),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(35),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 1,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
				]
			},
		]
	},
	"skeletal_warrior" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(170,30), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 180,
		"defense" : 13,
		"exp" : 35,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : slow,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0.8,
						"speed" : slow,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
				]
			}
		]
	},
	"skeletal_archer" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(210,30), Vector2(30,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1,2],
		},
		
		"health" : 90,
		"defense" : 10,
		"exp" : 35,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["highlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "ShadowArrow",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 0.2,
						"speed" : 45,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "ShadowArrow",
						"formula" : "0",
						"damage" : 20,
						"piercing" : true,
						"wait" : 4,
						"speed" : slow,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
				]
			}
		]
	},
	"cacodemon" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,18), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "cloud_isles"
		},
		
		"health" : 1200,
		"defense" : 12,
		"exp" : 200,
		"behavior" : 2,
		"speed" : 16,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0,1),
						"size" : medium
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0.866,0.5),
						"size" : medium
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0.866,-0.5),
						"size" : medium
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(0,-1),
						"size" : medium
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(-0.866,-0.5),
						"size" : medium
					},
					{
						"projectile" : "Void1",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 9,
						"targeter" : "nearest",
						"direction" : Vector2(-0.866,0.5),
						"size" : medium
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(7),
						"size" : medium
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : fast,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(15),
						"size" : medium
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : med,
						"tile_range" : 4,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-7),
						"size" : medium
					},
					{
						"projectile" : "RexiumSlash",
						"formula" : "0",
						"damage" : 70,
						"piercing" : false,
						"wait" : 0.2,
						"speed" : fast,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-15),
						"size" : medium
					},
				]
			},
		]
	},
	"basalisk" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(216,18), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"dungeon" : {
			"rate" : 0.05,
			"name" : "cloud_isles"
		},
		"health" : 1000,
		"defense" : 18,
		"exp" : 250,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 1.4,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "MithrilSlash",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Water2",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 1.4,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
				]
			},
		]
	},
	"phoenix" : {
		"scale" : 1,
		"res" : 18,
		"height" : 15,
		"rect" : Rect2(Vector2(126,18), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		"dungeon" : {
			"rate" : 0.05,
			"name" : "desert_catacombs"
		},
		"health" : 800,
		"defense" : 15,
		"exp" : 180,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-60),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : medium
					},
					{
						"projectile" : "Fire2",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
				]
			},
		]
	},
	"ice_druid" : {
		"scale" : 1,
		"res" : 18,
		"height" : 8,
		"rect" : Rect2(Vector2(90,18), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 90,
		"defense" : 10,
		"exp" : 55,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "RedBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 45,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 0,
						"speed" : 45,
						"tile_range" : 5,
						"targeter" : "nearest",
						"direction" : DegreesToVector(25),
						"size" : medium
					},
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 20,
						"piercing" : false,
						"wait" : 4,
						"speed" : 45,
						"tile_range" : 3,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-25),
						"size" : medium
					},
				]
			}
		]
	},
	"archmage" : {
		"scale" : 1,
		"res" : 18,
		"height" : 8,
		"rect" : Rect2(Vector2(36,18), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 700,
		"defense" : 15,
		"exp" : 225,
		"behavior" : 1,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(10,5),
						"wait" : 0,
					},
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(0,-5),
						"wait" : 0,
					},
					{
						"summon" : "ice_druid",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "BlueBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : small
					},
					{
						"projectile" : "RedBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(180),
						"size" : small
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 60,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(300),
						"size" : small
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(120),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 120,
						"piercing" : false,
						"wait" : 1.5,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(240),
						"size" : medium
					},
				]
			},
		]
	},
}
var orc_vigil_enemies = {
	"vigil_guardian" : {
		"scale" : 1.5,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(126,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health_scaling" : 10000,
		"health" : 50000,
		"defense" : 20,
		"exp" : 1000,
		"behavior" : 0,
		"speed" : 15,
		"dungeon" : {
			"rate" : 1,
			"name" : "orc_vigil_sanctum"
		},
		"loot_pool" : special_loot_pools["vigil_guardian"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"signal" : "stage_1",
						"reciever" : "orc_monolith",
						"duration" : OS.get_system_time_secs(),
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 12,
					},
					{
						"speech" : "So Oranix has fallen? The creator will be angry...",
						"wait" : 2,
					},
					{
						"speech" : "No matter. Those who enter the vigil shall not return. Die usurper!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 12,
				"health" : [90,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_fast", 15, 0, "nearest"),
					MakeProjectile("GiantBlast_fast", -15, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", (360.0/8.0)*8, 2, "nearest"),
				]
			},
			{
				"duration" : 4,
				"health" : [50,90],
				"behavior" : 2,
				"speed" : slow,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_medium", (360.0/3.0)*1, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", (360.0/3.0)*2, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", (360.0/3.0)*3, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*1)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*2)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*3)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*4)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*5)+30, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_1", ((360.0/6.0)*6)+30, 1, "nearest"),
				]
			},
			{
				"duration" : 4,
				"health" : [50,90],
				"behavior" : 0,
				"speed" : slow,
				"attack_pattern" : [
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*1), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*2), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*3), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*4), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*5), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*6), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*7), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*8), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*9), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*10), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*11), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*12), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*13), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*14), 0, "nearest"),
					MakeProjectile("VigilBlastSmall_slow", ((360.0/15.0)*15), 0.5, "nearest"),
				]
			},
			{
				"duration" : 4,
				"health" : [20,50],
				"behavior" : 0,
				"on_spawn" : true,
				"max_uses" : 1,
				"speed" : 10,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					{
						"speech" : "I have stood guard of this vigil for a millenium...",
						"wait" : 2,
					},
					{
						"speech" : "I will not fall to you lowly bottomfeeders!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [20,50],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_medium", 0, 0.2),
					MakeProjectile("NeonStar_strong_fast", 30, 0, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 30, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 30, 0.2),
					MakeProjectile("GiantBlast_medium", 60, 0.2),
					MakeProjectile("GiantBlast_medium", 90, 0.2),
					MakeProjectile("NeonStar_strong_fast", 120, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 120, 0.2),
					MakeProjectile("GiantBlast_medium", 150, 0.2),
					MakeProjectile("GiantBlast_medium", 180, 0.2),
					MakeProjectile("NeonStar_strong_fast", 0, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 210, 0.2),
					MakeProjectile("GiantBlast_medium", 240, 0.2),
					MakeProjectile("GiantBlast_medium", 270, 0.2),
					MakeProjectile("NeonStar_strong_fast", 90, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 300, 0.2),
					MakeProjectile("Wave_mid_fast", 30, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 20, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 10, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -30, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -20, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -10, 0, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 330, 0, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 270, 0, "nearest"),
				]
			},
		]
	},
	"orc_monolith" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
			"Death" : [1],
		},
		
		"health_scaling" : 1000,
		"health" : 2000,
		"defense" : 1,
		"exp" : 500,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 17,
					},
				]
			},
			{
				"duration" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"dead" : false,
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : OS.get_system_time_secs(),
						"wait" : 0.5,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"on_signal" : ["stage_1"],
				"attack_pattern" : [
					MakeProjectile("NeonArrow_mid_slow", 0, 0),
					MakeProjectile("NeonArrow_mid_slow", 90, 0),
					MakeProjectile("NeonArrow_mid_slow", 180, 0),
					MakeProjectile("NeonArrow_mid_slow", 270, 0.3),
				]
			},
			{
				"duration" : 1,
				"health" : [0,100],
				"on_signal" : ["stage_2"],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 1,
					},
				]
			}
		]
	},
	"atlas" : {
		"scale" : 1,
		"res" : 38,
		"height" : 20,
		"rect" : Rect2(Vector2(0,0), Vector2(114,38)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1,2],
		},
		
		"health_scaling" : 40000,
		"health" : 10000,
		"defense" : 0,
		"exp" : 1000,
		"behavior" : 0,
		"speed" : 15,
		"loot_pool" : special_loot_pools["atlas"],
		"phases" : [
			{
				"duration" : 18,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 18,
						"wait" : 12,
					},
					{
						"speech" : "This vigil is the only remnant of the old orc empire...",
						"wait" : 2,
					},
					{
						"speech" : "Do you really think it's treasures would lie undefended?",
						"wait" : 2,
					},
					{
						"speech" : "Prepare yourselves!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,25],
				"behavior" : 0,
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "Only by death is a true warrior defeated...",
						"wait" : 2,
					},
					{
						"signal" : "stage_2",
						"reciever" : "orc_monolith",
						"duration" : OS.get_system_time_secs(),
						"wait" : 0,
					},
					{
						"speech" : "Only by death is a true victor crowned!",
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 4,
				"max_uses" : 1,
				"behavior" : 0,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"speech" : "Bare witness to the power of orc magicks!",
						"wait" : 1,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(20,5),
						"wait" : 0,
					},
					{
						"summon" : "vigil_construct",
						"summon_position" : Vector2(-20,-5),
						"wait" : 5,
					},
				]
			},
			{
				"duration" : 6,
				"health" : [50,100],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*1, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*2, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*3, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*4, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*5, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*6, 0),
					
					] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 7) + [{"wait" : 0.5}] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 8) + [{"wait" : 0.5}] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 7) + [{"wait" : 0.5}] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 8) + [{"wait" : 0.5}] + [
					
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*7, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*8, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*9, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*10, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*11, 0),
					MakeProjectile("VigilBlast_strong_fast", (360.0/12.0)*12, 0),
				] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 7) + [{"wait" : 0.5}] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 8) + [{"wait" : 0.5}] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 7) + [{"wait" : 0.5}] + CreateSpiral(1, "VigilBlastSmall_strong_fast", 0, null, 0.2, 8) + [{"wait" : 0.5}]
			},
			{
				"duration" : 8,
				"health" : [50,100],
				"behavior" : 3,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("GiantBlast_fast", -25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 180, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -45, 0.1, "nearest"),
					MakeProjectile("Blast_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 220, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("GiantBlast_fast", 25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 160, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 30, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 200, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -10, 0.1, "nearest"),
				]
			},
			{
				"duration" : 8,
				"health" : [25,50],
				"behavior" : 1,
				"speed" : 17,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 90, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 180, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 270, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+0, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+90, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+180, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+270, 0, "nearest"),
					
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0.2, "nearest"),
				]
			},
			{
				"duration" : 8,
				"health" : [0,25],
				"behavior" : 1,
				"speed" : 20,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 90, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 180, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 270, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+0, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+90, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+180, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+270, 0, "nearest"),
					
					MakeProjectile("NeonArrow_mid_fast", 0, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 30, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", -30, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 15, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", -15, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 30, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", -30, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 15, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", -15, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 30, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", -30, 0.2, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 0, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", 15, 0, "nearest"),
					MakeProjectile("NeonArrow_mid_fast", -15, 0.2, "nearest"),
				]
			},
			{
				"duration" : 8,
				"health" : [0,50],
				"behavior" : 3,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("VigilBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 90, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 180, 0, "nearest"),
					MakeProjectile("VigilBlast_strong_fast", 270, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+0, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+90, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+180, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", 45+270, 0, "nearest"),
					
					MakeProjectile("GiantBlast_fast", -25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 180, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -45, 0.1, "nearest"),
					MakeProjectile("Blast_strong_fast", -5, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 220, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("GiantBlast_fast", 25, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 160, 0, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 30, 0.1, "nearest"),
					MakeProjectile("NeonStar_strong_fast", 200, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -10, 0.1, "nearest"),
				]
			},
		]
	},
	"vigil_construct" : {
		"scale" : 0.8,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(126,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health_scaling" : 1000,
		"health" : 2000,
		"defense" : 1,
		"exp" : 500,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"behavior" : 2,
				"speed" : 25,
				"attack_pattern" : [
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("VigilBlastSmall_strong_fast", (360.0/8.0)*8, 2, "nearest"),
				]
			},
		]
	},
}
var frozen_fortress_enemies = {
	"frozen_monolith" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,72), Vector2(18,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"health_scaling" : 1000,
		"health" : 2000,
		"defense" : 1,
		"exp" : 500,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 106,
					"chance" : 1000,
					"threshold" : 0.5,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"signal" : "monolith_active",
						"reciever" : "og_the_treacherous",
						"duration" : 2,
						"wait" : 0,
					},
					MakeProjectile("IceSlash_weak_medium", (360.0/3.0)*1, 0, "nearest"),
					MakeProjectile("IceSlash_weak_medium", (360.0/3.0)*2, 0, "nearest"),
					MakeProjectile("IceSlash_weak_medium", (360.0/3.0)*3, 1, "nearest"),
				]
			},
		]
	},
	"frozen_barrier" : {
		"scale" : 0.9,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,72), Vector2(18,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"health" : 1,
		"defense" : 1,
		"exp" : 0,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 5,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : OS.get_system_time_msecs(),
						"wait" : 5,
					},
				]
			},
			{
				"duration" : 16,
				"health" : [0,100],
				"attack_pattern" : [{"wait" : 0.5}] + CreateSpiral(1, "Wave_strong_fast_short", 0, null, 0.2, 8)
			},
		]
	},
	"og_the_treacherous" : {
		"scale" : 1,
		"res" : 38,
		"height" : 28,
		"rect" : Rect2(Vector2(0,76), Vector2(190,38)),
		"custom_hitbox" : Vector2(24,24),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
			"Death" : [4],
		},
		
		"health_scaling" : 30000,
		"health" : 10000,
		"defense" : 20,
		"exp" : 1000,
		"behavior" : 0,
		"speed" : 15,
		"loot_pool" : special_loot_pools["og_the_treacherous"],
		"phases" : [
			{
				"duration" : 17,
				"health" : [99.99,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"on_signal" : ["monolith_active"],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : 16,
						"wait" : 8,
					},
					{
						"speech" : "I was trapped here by the troll lords many decades ago...",
						"wait" : 3,
					},
					{
						"speech" : "The four frozen monoliths are keeping me here and restricting my power!",
						"wait" : 3,
					},
					{
						"speech" : "If you can destroy them all I will give you a great reward.",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 1,
				"health" : [90,100],
				"on_signal" : ["monolith_active"],
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 1.5,
						"wait" : 1,
					},
				]
			},
			{
				"duration" : 1,
				"health" : [99.99,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 2,
						"wait" : 0,
					},
					{
						"dead" : true,
						"wait" : 1,
					},
				]
			},
			{
				"duration" : 14,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 17,
						"wait" : 0,
					},
					{
						"wait" : 5,
					},
					{
						"speech" : "Yes! My power! I feel it returning...",
						"wait" : 0,
					},
					{
						"dead" : false,
						"wait" : 0.3,
					},
					{
						"dead" : true,
						"wait" : 0.3,
					},
					{
						"dead" : false,
						"wait" : 0.3,
					},
					{
						"dead" : true,
						"wait" : 0.3,
					},
					{
						"dead" : false,
						"wait" : 0.3,
					},
					{
						"dead" : true,
						"wait" : 0.3,
					},
					{
						"dead" : false,
						"wait" : 3,
					},
					{
						"speech" : "Thank you mortals, but unfourtunately...",
						"wait" : 3,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(11*8,0),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(11*8,8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(11*8,16),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(11*8,-8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(-11*8,0),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(-11*8,8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(-11*8,16),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(-11*8,-8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(0,11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(8,11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(16,11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(-8,11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(0,-11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(8,-11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(-8,-11*8),
						"wait" : 0,
					},
					{
						"summon" : "frozen_barrier",
						"summon_position" : Vector2(16,-11*8),
						"wait" : 0,
					},
					{
						"speech" : "I cannot risk you telling the trolls of my freedom! Feel the power of winter!",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 5,
				"health" : [66,100],
				"attack_pattern" : CreateSpiral(3, "AbyssSpinner_strong_medium", 0.3, "IceSpinner_strong_fast", 0.4)
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 10,
				"health" : [66,100],
				"attack_pattern" : CreateSpiral(4, "GiantIceBlast_fast_strong", 0.2, null, 0.2, 4) + [
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*1, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*2, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*3, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*4, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*5, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*6, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*7, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*8, 0.5),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*1, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*2, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*3, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*4, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*5, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*6, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*7, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*8, 0.5),
				] + CreateSpiral(4, "GiantIceBlast_fast_strong", 0.2, null, 0.2, 4) + [
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*9, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*10, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*11, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*12, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*13, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*14, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*15, 0),
					MakeProjectile("IceSpinner_strong_fast", (360.0/16.0)*16, 0.5),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*9, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*10, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*11, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*12, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*13, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*14, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*15, 0),
					MakeProjectile("IceBlast_mid_fast", (360.0/16.0)*16, 0.5),
				]
			},
			{
				"duration" : 7,
				"behavior" : 0,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [33,66],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 7,
						"wait" : 1,
					},
					{
						"speech" : "You are stronger then I anticipated...",
						"wait" : 3,
					},
					{
						"speech" : "I must use my full power, prepare to die!",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 12,
				"behavior" : 2,
				"speed" : 5,
				"health" : [33,66],
				"attack_pattern" : [
					MakeProjectile("GiantIceSpinner_strong_fast", 45, 0, "nearest"),
					MakeProjectile("GiantIceSpinner_strong_fast", -89, 0, "nearest"),
					MakeProjectile("GiantIceBlast_fast_strong", 22, 0, "nearest"),
					MakeProjectile("GiantIceBlast_fast_strong", -10, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*3, 0.5, "nearest"),
					
					MakeProjectile("GiantIceSpinner_strong_fast", 77, 0, "nearest"),
					MakeProjectile("GiantIceSpinner_strong_fast", -35, 0, "nearest"),
					MakeProjectile("GiantIceBlast_fast_strong", 10, 0, "nearest"),
					MakeProjectile("GiantIceBlast_fast_strong", -56, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*8, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*6, 0.5, "nearest"),
				] + CreateSpiral(1, "IceSlash_mid_fast", 0.1, null, 0.2, 9)
			},
			{
				"duration" : 8,
				"behavior" : 2,
				"speed" : 2,
				"health" : [33,66],
				"attack_pattern" : CreateSpiral(1, "GiantIceSlash_mid_slow", 0.2, "GiantIceSpinner_strong_fast", 0.5, 24) + [
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", (360.0/8.0)*8, 1, "nearest"),
				]
			},
			{
				"duration" : 7,
				"behavior" : 0,
				"speed" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,33],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 7,
						"wait" : 1,
					},
					{
						"speech" : "FOOLS! You battle with a general of Vexuvious...",
						"wait" : 3,
					},
					{
						"speech" : "YOU HAVE NO UNDERSTANDING OF MY POWER!",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 8,
				"behavior" : 2,
				"speed" : 6,
				"health" : [0,33],
				"attack_pattern" : [
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*2, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*3, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*4, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*5, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*6, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*7, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*8, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*9, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*10, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*11, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*12, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*13, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*14, 0, "nearest"),
					
					MakeProjectile("IceSpinner_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", 5, 0.2, "nearest"),
					MakeProjectile("IceBlast_mid_fast", 0, 0.2, "nearest"),
					
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*2, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*3, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*4, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*5, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*6, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*7, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*8, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*9, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*10, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*11, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*12, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*13, 0, "nearest"),
					MakeProjectile("GiantIceSlash_strong_fast", (360.0/16.0)*14, 0, "nearest"),
					
					MakeProjectile("IceSpinner_strong_fast", -20, 0.2, "nearest"),
					MakeProjectile("IceSlash_strong_fast", 15, 0.2, "nearest"),
					MakeProjectile("AbyssBlast_strong_mid", -5, 0.2, "nearest"),
					MakeProjectile("IceSpinner_strong_fast", 0, 0.2, "nearest"),
				]
			},
		]
	},
	"ice_spirit" : {
		"scale" : 0.9,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0,1],
		},
		
		"health" : 200,
		"defense" : 0,
		"exp" : 50,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_weak_fast", 0, 2, "nearest"),
				]
			}
		]
	},
	"ice_golem" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(108,72), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 2000,
		"defense" : 20,
		"exp" : 250,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "ice_spirit",
						"summon_position" : Vector2(-19,-1),
						"wait" : 0,
					},
					{
						"summon" : "ice_spirit",
						"summon_position" : Vector2(20,-1),
						"wait" : 0,
					},
					{
						"summon" : "ice_spirit",
						"summon_position" : Vector2(0,-20),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 16,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("IceSlash_mid_fast", 60+(360.0/3.0)*1, 0, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 60+(360.0/3.0)*2, 0, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 60+(360.0/3.0)*3, 1, "nearest"),
					MakeProjectile("IceSpinner_mid_medium", (360.0/3.0)*1, 0, "nearest"),
					MakeProjectile("IceSpinner_mid_medium", (360.0/3.0)*2, 0, "nearest"),
					MakeProjectile("IceSpinner_mid_medium", (360.0/3.0)*3, 2, "nearest"),
				]
			},
		]
	},
	"ice_demon" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(162,72), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 3000,
		"defense" : 10,
		"exp" : 350,
		"behavior" : 2,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Ball_weak_fast", (360.0/6.0)*1, 0, "nearest"),
					MakeProjectile("Ball_weak_fast", (360.0/6.0)*2, 0, "nearest"),
					MakeProjectile("Ball_weak_fast", (360.0/6.0)*3, 0, "nearest"),
					MakeProjectile("Ball_weak_fast", (360.0/6.0)*4, 0, "nearest"),
					MakeProjectile("Ball_weak_fast", (360.0/6.0)*5, 0, "nearest"),
					MakeProjectile("Ball_weak_fast", (360.0/6.0)*6, 0, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("IceSlash_mid_fast", 0, 0.2, "nearest"),
				]
			},
		]
	},
	"ice_troll_guardian" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(198,72), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 2000,
		"defense" : 15,
		"exp" : 150,
		"behavior" : 1,
		"speed" : 15,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "ice_troll",
						"summon_position" : Vector2(-19,-1),
						"wait" : 0,
					},
					{
						"summon" : "ice_troll",
						"summon_position" : Vector2(20,-1),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : CreateSpiral(2, "IceSpinner_mid_medium", 0.4)
			},
		]
	},
	"ice_troll" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(20,40), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [1,2],
		},
		
		"health" : 600,
		"defense" : 0,
		"exp" : 50,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("IceSlash_weak_slow", 0, 0.8, "nearest"),
				]
			}
		]
	},
}
var desert_catacombs_enemies = {
	"mummified_spider" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,126), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 3000,
		"defense" : 20,
		"exp" : 500,
		"behavior" : 2,
		"speed" : 5,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "mummified_spider_egg",
						"summon_position" : Vector2(-19,-1),
						"wait" : 0,
					},
					{
						"summon" : "mummified_spider_egg",
						"summon_position" : Vector2(20,-5),
						"wait" : 0,
					},
					{
						"summon" : "mummified_spider_egg",
						"summon_position" : Vector2(0,-18),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 16,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("RoyalSlash_weak_medium", 20, 0, "nearest"),
					MakeProjectile("RoyalSlash_weak_medium", 0, 0, "nearest"),
					MakeProjectile("RoyalSlash_weak_medium", -20, 0.5, "nearest"),
					MakeProjectile("Wave_weak_fast", 20, 0, "nearest"),
					MakeProjectile("Wave_weak_fast", 0, 0, "nearest"),
					MakeProjectile("Wave_weak_fast", -20, 2, "nearest"),
				]
			},
		]
	},
	"mummified_spider_egg" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(60,40), Vector2(10,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"health" : 1000,
		"defense" : 0,
		"exp" : 50,
		"behavior" : 0,
		"speed" : 4,
		
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 538,
					"chance" : 1000,
					"threshold" : 0.5,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*1, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*2, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*3, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*4, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*5, 2),
				]
			}
		]
	},
	"sand_golem" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(54,126), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,2],
		},
		
		"health" : 1000,
		"defense" : 20,
		"exp" : 500,
		"behavior" : 1,
		"speed" : 11,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "sand_sprite",
						"summon_position" : Vector2(0,-1),
						"wait" : 0,
					},
					{
						"summon" : "sand_sprite",
						"summon_position" : Vector2(0,5),
						"wait" : 0,
					},
					{
						"summon" : "sand_sprite",
						"summon_position" : Vector2(0,-5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 32,
				"health" : [0,100],
				"attack_pattern" : CreateSpiral(2, "SandBlast_mid_medium", 0.3, "RoyalSlash_weak_medium", 0.3)
			},
		]
	},
	"sand_sprite" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(70,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 200,
		"defense" : 0,
		"exp" : 50,
		"behavior" : 2,
		"speed" : slow,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("SandBlastSmall_mid_fast", 10, 0, "nearest"),
					MakeProjectile("SandBlastSmall_mid_fast", -10, 0.5, "nearest"),
				]
			}
		]
	},
	"mummified_ghoul" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(108,126), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 2000,
		"defense" : 10,
		"exp" : 500,
		"behavior" : 2,
		"speed" : 25,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "mini_mummified_ghoul",
						"summon_position" : Vector2(10,-10),
						"wait" : 0,
					},
					{
						"summon" : "mini_mummified_ghoul",
						"summon_position" : Vector2(-10,5),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 32,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("SandBlast_mid_medium", (360.0/8.0)*8, 3, "nearest"),
				]
			},
		]
	},
	"mini_mummified_ghoul" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(90,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 500,
		"defense" : 0,
		"exp" : 50,
		"behavior" : 1,
		"speed" : 15,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("SandBlastSmall_strong_medium", (360.0/4.0)*1, 0, "nearest"),
					MakeProjectile("SandBlastSmall_strong_medium", (360.0/4.0)*2, 0, "nearest"),
					MakeProjectile("SandBlastSmall_strong_medium", (360.0/4.0)*3, 0, "nearest"),
					MakeProjectile("SandBlastSmall_strong_medium", (360.0/4.0)*4, 2, "nearest"),
				]
			}
		]
	},
	"mummified_king" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(144,126), Vector2(72,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 30000,
		"defense" : 5,
		"exp" : 1000,
		"behavior" : 0,
		"speed" : 25,
		"loot_pool" : special_loot_pools["mummified_king"],
		"phases" : [
			{
				"duration" : 7,
				"health" : [25,100],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("SandBlast_strong_fast", (360.0/6.0)*1, 0),
					MakeProjectile("SandBlast_strong_fast", (360.0/6.0)*2, 0),
					MakeProjectile("SandBlast_strong_fast", (360.0/6.0)*3, 0),
					MakeProjectile("SandBlast_strong_fast", (360.0/6.0)*4, 0),
					MakeProjectile("SandBlast_strong_fast", (360.0/6.0)*5, 0),
					MakeProjectile("SandBlast_strong_fast", (360.0/6.0)*6, 0),
					MakeProjectile("SandBlastSmall_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 0, 0.1, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 0, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("SandBlastSmall_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("SandBlast_strong_fast", 30+(360.0/6.0)*1, 0),
					MakeProjectile("SandBlast_strong_fast", 30+(360.0/6.0)*2, 0),
					MakeProjectile("SandBlast_strong_fast", 30+(360.0/6.0)*3, 0),
					MakeProjectile("SandBlast_strong_fast", 30+(360.0/6.0)*4, 0),
					MakeProjectile("SandBlast_strong_fast", 30+(360.0/6.0)*5, 0),
					MakeProjectile("SandBlast_strong_fast", 30+(360.0/6.0)*6, 0),
					MakeProjectile("RoyalSlash_mid_fast", 0, 0.1, "nearest"),
					MakeProjectile("SandBlastSmall_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("RoyalSlash_mid_fast", 0, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 0, 0.1, "nearest"),
					MakeProjectile("SandBlastSmall_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 0, 0.2, "nearest"),
				]
			},
			{
				"duration" : 7,
				"health" : [25,100],
				"behavior" : 0,
				"speed" : 10,
				"attack_pattern" : CreateSpiral(2, "RoyalSlash_mid_fast", 0.2, "BlueBlast_strong_fast", 0.4)
			},
			{
				"duration" : 7,
				"health" : [25,100],
				"behavior" : 1,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("SandBlast_strong_medium", (360.0/3.0)*1, 0),
					MakeProjectile("SandBlast_strong_medium", (360.0/3.0)*2, 0),
					MakeProjectile("SandBlast_strong_medium", (360.0/3.0)*3, 0.3),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*1, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*2, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*3, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*4, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*5, 0.3),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*1, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*2, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*3, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*4, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*5, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*6, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*7, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*8, 0.3),
				]
			},
			{
				"duration" : 7,
				"behavior" : 1,
				"speed" : 10,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0, 25],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 7,
						"wait" : 1,
					},
					{
						"speech" : "I once ruled over this kingdom...",
						"wait" : 3,
					},
					{
						"speech" : "MY POWER IS STILL BEYOND YOUR GRASP!",
						"wait" : 4,
					},
				]
			},
			{
				"duration" : 7,
				"health" : [0,25],
				"behavior" : 2,
				"speed" : 10,
				"attack_pattern" : [
					MakeProjectile("GiantRoyalSlash_strong_medium", 20, 0, "nearest"),
					MakeProjectile("GiantRoyalSlash_strong_medium", -20, 0, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 5, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", -5, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", -10, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", -5, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 5, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 5, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", -5, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", -10, 0.1, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", -5, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 0, 0.2, "nearest"),
					MakeProjectile("BlueBlast_strong_fast", 5, 0.1, "nearest"),
					
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*1, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*2, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*3, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*4, 0),
					MakeProjectile("RoyalSlash_strong_medium", (360.0/5.0)*5, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*1, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*2, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*3, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*4, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*5, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*6, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*7, 0),
					MakeProjectile("BlueBlast_strong_fast", (360.0/8.0)*8, 0),
				]
			},
		]
	},
}
var rocky_cave_enemies = {
	"rokk_the_rough" : {
		"scale" : 1.5,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(36,108), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 6000,
		"defense" : 0,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : special_loot_pools["rokk_the_rough"],
		"phases" : [
			{
				"duration" : 7,
				"health" : [33,100],
				"attack_pattern" : [
					MakeProjectile("Wave_mid_fast", 20, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -20, 0.5, "nearest"),
					MakeProjectile("RockBlastSmall_mid_fast", 20, 0, "nearest"),
					MakeProjectile("RockBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("RockBlastSmall_mid_fast", -20, 2, "nearest"),
				]
			},
			{
				"duration" : 7,
				"health" : [33,100],
				"attack_pattern" : CreateSpiral(2, "RockBlastSmall_strong_medium", 0.1, "RockBlastSmall_mid_fast", 0.8)
			},
			{
				"duration" : 7,
				"health" : [0,33],
				"behavior" : 2,
				"speed" : 5,
				"attack_pattern" :  [
					{
						"summon" : "rock_sprite_rotating",
						"summon_position" : DegreesToVector(0)*30,
						"wait" : 1,
					},
				] + CreateSpiral(2, "RockBlast_strong_fast", 0.3, "RockBlastSmall_mid_fast", 0.8)
			},
		]
	},
	"rock_sprite_rotating" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(220,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		
		"health" : 100,
		"defense" : 5,
		"exp" : 30,
		"behavior" : 3,
		"anchor" : "parent",
		"speed" : 15,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_weak_fast", 0, 0.4, "nearest"),
				]
			}
		]
	},
	"lil_rock_golem" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(200,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 200,
		"defense" : 0,
		"exp" : 30,
		"behavior" : 2,
		"speed" : 4,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*1, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*2, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*3, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*4, 0),
					MakeProjectile("Wave_weak_fast", (360.0/5.0)*5, 2),
				]
			}
		]
	},
	"rock_sprite" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(220,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		
		"health" : 100,
		"defense" : 5,
		"exp" : 30,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_weak_fast", 0, 0.4, "nearest"),
				]
			}
		]
	},
	"rock_scorpion" : {
		"scale" : 1.2,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(240,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		
		"health" : 200,
		"defense" : 0,
		"exp" : 60,
		"behavior" : 2,
		"speed" : 7,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Ball_mid_fast", 0, 0.7, "nearest"),
				]
			}
		]
	},
}
var cloud_isles_enemies = {
	"pohaku" : {
		"scale" : 1.5,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(216,108), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 50000,
		"defense" : 20,
		"exp" : 1000,
		"behavior" : 0,
		"speed" : 5,
		"loot_pool" : special_loot_pools["pohaku"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "gold_protector",
						"summon_position" : DegreesToVector(0)*30,
						"wait" : 0,
					},
					{
						"summon" : "gold_protector",
						"summon_position" : DegreesToVector(120)*30,
						"wait" : 0,
					},
					{
						"summon" : "gold_protector",
						"summon_position" : DegreesToVector(240)*30,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [99.99,100],
				"attack_pattern" : [
					{
						"wait" : OS.get_system_time_secs(),
					},
				]
			},
			{
				"on_spawn" : true,
				"duration" : 1,
				"health" : [0,100],
				"on_signal" : ["protractors_active"],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 2,
						"wait" : 1,
					},
				]
			},
			
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,99.99],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "You made it all the way up here by yourself?",
						"wait" : 3,
					},
					{
						"signal" : "activate_protectors_1",
						"reciever" : "gold_protector",
						"duration" : OS.get_system_time_msecs(),
						"wait" : 0,
					},
					{
						"speech" : "Impressive! But the clouds belong to me, and you'll fall like all the rest!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [66,99.99],
				"attack_pattern" : [
					MakeProjectile("GoldenArrow_weak_medium", 0, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_weak_medium", 0, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_weak_medium", 0, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_weak_medium", 0, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_weak_medium", 0, 0, "nearest"),
					MakeProjectile("Wave_strong_slow", 20, 0.2, "nearest"),
					MakeProjectile("Wave_strong_slow", 0, 0.2, "nearest"),
					MakeProjectile("Wave_strong_slow", -20, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_weak_medium", 0, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_weak_medium", 0, 0.2, "nearest"),
				] + CreateSpiral(1, "GiantBlast_fast", 0, null, 0, 6)
			},
			
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,66],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "What? You think you can damage me?",
						"wait" : 3,
					},
					{
						"signal" : "activate_protectors_2",
						"reciever" : "gold_protector",
						"duration" : OS.get_system_time_msecs(),
						"wait" : 0,
					},
					{
						"speech" : "My body is a temple!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [33,66],
				"attack_pattern" : [
					{"wait" : 0.2,},
					MakeProjectile("GoldenArrow_mid_medium", 0, 0.2, "nearest"),
					MakeProjectile("Wave_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_mid_medium", -10, 0.2, "nearest"),
					MakeProjectile("Wave_strong_fast", 5, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_mid_medium", 15, 0.2, "nearest"),
					MakeProjectile("Wave_strong_fast", -15, 0.2, "nearest"),
					MakeProjectile("GoldenArrow_mid_medium", -5, 0.2, "nearest"),
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 3) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 6) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 9)
			},
			
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,33],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "Rahh!",
						"wait" : 3,
					},
					{
						"signal" : "activate_protectors_3",
						"reciever" : "gold_protector",
						"duration" : OS.get_system_time_msecs(),
						"wait" : 0,
					},
					{
						"speech" : "I am worth my weight in gold!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [0,33],
				"attack_pattern" : [
					{"wait" : 0.5,},
					MakeProjectile("GiantBlast_medium", 0, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 5, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 15, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -15, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -5, 0.2, "nearest"),
					{"wait" : 0.5,},
				] + CreateSpiral(1, "GoldenArrow_mid_medium", 0, "SmallBlast_strong_fast", 0.4, 8) + [
					{"wait" : 0.2,},
					MakeProjectile("GiantBlast_medium", 0, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 10, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 5, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", 15, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -15, 0.2, "nearest"),
					MakeProjectile("SmallBlast_strong_fast", -5, 0.2, "nearest"),
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 16) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 20) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 16) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 20) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 16) + [
					{"wait" : 0.5,},
				] + CreateSpiral(1, "Wave_strong_slow", 0, null, 0, 20) + [
					{"wait" : 0.5,},
				]
			},
		]
	},
	"gold_protector" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(252,108), Vector2(18,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [0],
		},
		
		"health" : 10000,
		"defense" : 0,
		"exp" : 100,
		"anchor" : "parent",
		"behavior" : 3,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 2,
						"wait" : 1,
					},
				]
			},
			{
				"on_spawn" : true,
				"duration" : OS.get_system_time_secs(),
				"health" : [66,100],
				"speed" : 6,
				"on_signal" : ["activate_protectors_1"],
				"attack_pattern" : [
					{
						"signal" : "protractors_active",
						"reciever" : "parent",
						"duration" : 0.6,
						"wait" : 0.5,
					},
					MakeProjectile("Wave_mid_fast", 0, 0, "nearest")
				] + CreateSpiral(1,"Wave_weak_slow",0,null,0.2,3)
			},
			{
				"on_spawn" : true,
				"duration" : OS.get_system_time_secs(),
				"health" : [33,66],
				"speed" : 10,
				"on_signal" : ["activate_protectors_2"],
				"attack_pattern" : [
					{
						"signal" : "protractors_active",
						"reciever" : "parent",
						"duration" : 0.6,
						"wait" : 0.5,
					},
					MakeProjectile("Wave_strong_fast", 0, 0, "nearest")
				] + CreateSpiral(1,"Wave_mid_slow",0,null,0.2,5)
			},
			{
				"on_spawn" : true,
				"duration" : OS.get_system_time_secs(),
				"health" : [0,33],
				"speed" : 12,
				"on_signal" : ["activate_protectors_3"],
				"attack_pattern" : [
					{
						"signal" : "protractors_active",
						"reciever" : "parent",
						"duration" : 0.6,
						"wait" : 0.5,
					},
					MakeProjectile("Stack_strong_medium", 0, 0, "nearest")
				] + CreateSpiral(1,"Wave_mid_fast",0,null,0.2,8)
			},
		]
	},
	"blue_basalisk" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,108), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 3400,
		"defense" : 18,
		"exp" : 500,
		"behavior" : 2,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0.8,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 1,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
				]
			},
		]
	},
	"giant_vermin" : {
		"scale" : 1.1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(144,108), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 4000,
		"defense" : 10,
		"exp" : 500,
		"behavior" : 1,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : CreateSpiral(1, "Nature1_mid_medium", 0, null, 0, 8) + [
					{
						"wait" : 0.5
					},
					{
						"projectile" : "Nature3",
						"formula" : "0",
						"damage" : 100,
						"piercing" : true,
						"wait" : 0.5,
						"speed" : fast,
						"tile_range" : 6,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
				]
			},
		]
	},
	"gold_guardian" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(180,108), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 4000,
		"defense" : 20,
		"exp" : 500,
		"behavior" : 0,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "gold_idol",
						"summon_position" : DegreesToVector(0)*12,
						"wait" : 0,
					},
					{
						"summon" : "gold_idol",
						"summon_position" : DegreesToVector(120)*12,
						"wait" : 0,
					},
					{
						"summon" : "gold_idol",
						"summon_position" : DegreesToVector(240)*12,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : CreateSpiral(2, "Blast_strong_fast", 0.2, "GoldenArrow_mid_medium", 0.5, 32)
			},
		]
	},
	"gold_idol" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(20,50), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 100,
		"defense" : 100,
		"exp" : 100,
		"anchor" : "parent",
		"behavior" : 3,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("SmallBlast_strong_fast", 0, 1, "nearest")
				] + CreateSpiral(1,"Wave_weak_fast",0,null,0.2,5)
			},
		]
	},
	"cloud_sprite" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,50), Vector2(20,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 300,
		"defense" : 0,
		"exp" : 100,
		"behavior" : 2,
		"speed" : 15,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Wave_weak_slow", 0, 0, "nearest"),
					MakeProjectile("Wave_weak_fast", 0, 1, "nearest"),
				]
			},
		]
	},
}
var the_abyss_enemies = {
	"salazar,_rex_of_the_abyss" : {
		"scale" : 1,
		"res" : 38,
		"height" : 34,
		"rect" : Rect2(Vector2(114,0), Vector2(114,38)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [1,2],
		},
		
		"health_scaling" : 40000,
		"health" : 10000,
		"defense" : 10,
		"exp" : 1000,
		"behavior" : 0,
		"speed" : 40,
		"loot_pool" : special_loot_pools["salazar,_rex_of_the_abyss"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 17,
						"wait" : 12,
					},
					{
						"speech" : "Now your in MY domain...",
						"wait" : 4,
					},
					{
						"speech" : "I will die before letting you take this kingdom!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 8,
				"health" : [0,88],
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"speech" : "Feel the inferno!",
						"wait" : 1,
					},
				] + CreateSpiral(12, "FlameBlast_strong_slow", 0.2, "GiantFlameArrow_strong_fast", 0.3, 24) + [{"wait" : 4}]
			},
			{
				"duration" : 8,
				"health" : [0,55],
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"speech" : "Feel the inferno!",
						"wait" : 1,
					},
				] + CreateSpiral(14, "FlameBlast_strong_slow", 0.3, "GiantFlameArrow_strong_fast", 0.5, 32)+ [{"wait" : 4}]
			},
			{
				"duration" : 8,
				"health" : [0,33],
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					{
						"speech" : "Feel the inferno!",
						"wait" : 1,
					},
				] + CreateSpiral(16, "FlameBlast_strong_fast", 0.2, "GiantFlameArrow_strong_fast", 1, 32)+ [{"wait" : 4}]
			},
			{
				"duration" : 8,
				"health" : [75,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*1, 0),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*2, 0),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*3, 0),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*4, 0.3),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*3, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*4, 0.2),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*4), 0.3),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*3, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*4, 0.2),
				]
			},
			{
				"duration" : 6,
				"health" : [75,100],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*1, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*2, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*3, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*4, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*5, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*6, 0.3),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*1, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*2, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*3, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*4, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*5, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*6, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*7, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*8, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*9, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*10, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*11, 0.1),
					MakeProjectile("FlameArrow_mid_fast", (360.0/12.0)*12, 0.3),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*7, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*8, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*9, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*10, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*11, 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", (360.0/12.0)*12, 0.1),
				]
			},
			{
				"duration" : 6,
				"health" : [75,100],
				"behavior" : 0,
				"speed" : 15,
				"attack_pattern" : CreateSpiral(3, "FlameBurst_strong_slow", 0.15, "FlameBurst_strong_fast", 0.3, 16)
			},
			{
				"duration" : 10,
				"health" : [25,75],
				"behavior" : 1,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*1, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*3, 1),
					MakeProjectile("GiantFlameArrow_strong_fast", 0+((360.0/4.0)*1), 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*3), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*3), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*3), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*3), 0.5),
					
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*2, 0),
					MakeProjectile("FlameArrow_mid_fast", (360.0/4.0)*4, 1),
					MakeProjectile("GiantFlameArrow_strong_fast", 0+((360.0/4.0)*2), 0.1),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 10+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -10+((360.0/4.0)*4), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 20+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -20+((360.0/4.0)*4), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 30+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -30+((360.0/4.0)*4), 0.1),
					
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", 40+((360.0/4.0)*4), 0),
					MakeProjectile("GiantFlameArrow_strong_fast", -40+((360.0/4.0)*4), 0.5),
				]
			},
			{
				"duration" : 5,
				"health" : [25,75],
				"behavior" : 2,
				"speed" : 15,
				"attack_pattern" : [
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0.3, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0.3, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 0, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", 10, 0, "nearest"),
					MakeProjectile("FlameBlast_strong_fast", -10, 0.3, "nearest"),
					
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*1, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*2, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*3, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_medium", (360.0/4.0)*4, 0.2, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*1, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*2, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*3, 0, "nearest"),
					MakeProjectile("GiantFlameBlast_strong_fast", 45+(360.0/4.0)*4, 0.2, "nearest"),
				]
			},
			{
				"duration" : 6,
				"health" : [25,75],
				"behavior" : 0,
				"speed" : 15,
				"attack_pattern" : CreateSpiral(1, "GiantFlameBlast_strong_medium", 0.05, "FlameArrow_mid_fast", 0.8, 12)
			},
			{
				"duration" : 6,
				"health" : [0,25],
				"on_spawn" : true,
				"max_uses" : 1,
				"behavior" : 0,
				"speed" : 15,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 3,
					},
					{
						"speech" : "In this kingdom, I alone am the strongest!",
						"wait" : 2,
					},
					#{
						#"summon" : "fireball",
						#"summon_position" : Vector2(8*5,0),
						#"wait" : 0,
					#},
					#{
						#"summon" : "fireball",
						#"summon_position" : Vector2(-8*5,0),
						#"wait" : 2,
					#},
				]
			},
			{
				"duration" : 20,
				"health" : [0,25],
				"behavior" : 2,
				"speed" : 5,
				"attack_pattern" : [
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*1, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*2, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*3, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*4, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*5, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*6, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*7, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*8, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*9, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*10, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*11, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*12, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*13, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*14, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*15, 0),
					MakeProjectile("FlameArrow_strong_fast_short", (360.0/16.0)*16, 0.1),
					
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 0+((360.0/4.0)*4), 0.1),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*1), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*2), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*3), 0),
					MakeProjectile("GiantFlameBlast_strong_medium", 45+((360.0/4.0)*4), 0.5),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 0, 0.1, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", 10, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -10, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 20, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -20, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 30, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -30, 0.1, "nearest"),
					
					MakeProjectile("GiantFlameArrow_strong_medium", 40, 0, "nearest"),
					MakeProjectile("GiantFlameArrow_strong_medium", -40, 1, "nearest"),
				]
			},
		]
	},
	"fireball" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(234,54), Vector2(36,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [1],
		},
		
		"health" : 100,
		"defense" : 0,
		"exp" : 100,
		"anchor" : "parent",
		"behavior" : 3,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 4,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 5,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"behavior" : 2,
				"speed" : 40,
				"attack_pattern" : CreateSpiral(2, "PlasmaBall_mid_mid", 0.3)
			},
		]
	},
}
var ruined_temple_enemies = {
	"imp_general" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(198,90), Vector2(36,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 2000,
		"defense" : 10,
		"exp" : 400,
		"behavior" : 2,
		"speed" : 8,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,50],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "imp_legionnaire",
						"summon_position" : Vector2(10,0),
						"wait" : 0,
					},
					{
						"summon" : "imp_legionnaire",
						"summon_position" : Vector2(-10,0),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : [
					MakeProjectile("RoyalSlash_strong_medium", 10, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_medium", 0, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_medium", -10, 1, "nearest"),
					MakeProjectile("Wave_mid_fast", 10, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -10, 2, "nearest"),
				]
			},
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					MakeProjectile("RoyalSlash_strong_medium", 10, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_medium", 0, 0, "nearest"),
					MakeProjectile("RoyalSlash_strong_medium", -10, 1, "nearest"),
					MakeProjectile("Wave_mid_fast", 10, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", 0, 0, "nearest"),
					MakeProjectile("Wave_mid_fast", -10, 2, "nearest"),
				]
			}
		]
	},
	"imp_legionnaire" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(160,40), Vector2(40,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2,3],
		},
		
		"health" : 1000,
		"defense" : 20,
		"exp" : 100,
		"behavior" : 2,
		"speed" : 15,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("RoyalSlash_strong_fast_short", 0, 0.4, "nearest"),
				]
			}
		]
	},
	"demonic_spirit" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(162,90), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 4000,
		"defense" : 10,
		"exp" : 500,
		"behavior" : 1,
		"speed" : slow,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 0.5,
				"health" : [0,99.99999],
				"on_spawn" : true,
				"max_uses" : 3,
				"attack_pattern" : [
					{
						"summon" : "lesser_demonic_spirit",
						"summon_position" : Vector2(0,0),
						"wait" : 0.6,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [99.99999,100],
				"attack_pattern" : CreateSpiral(3, "BloodShuriken1", 0.2, null, 0.2, 16)
			},
			{
				"duration" : 10,
				"health" : [0,99.99999],
				"attack_pattern" : CreateSpiral(3, "BloodShuriken1", 0.2, null, 0.2, 16)
			}
		]
	},
	"lesser_demonic_spirit" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(140,40), Vector2(20,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [],
		},
		
		"health" : 100,
		"defense" : 10,
		"exp" : 100,
		"behavior" : 2,
		"speed" : 25,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : CreateSpiral(1, "BloodSpinner_weak_fast", 0, null, 0.2, 5) + [MakeProjectile("None", -10, 1, "nearest")]
			}
		]
	},
	"demonic_beast" : {
		"scale" : 1.2,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(126,90), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 3000,
		"defense" : 20,
		"exp" : 500,
		"behavior" : 1,
		"speed" : 3,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"summon" : "demonic_fledgling",
						"summon_position" : Vector2(-19,-1),
						"wait" : 0,
					},
					{
						"summon" : "demonic_fledgling",
						"summon_position" : Vector2(20,-5),
						"wait" : 0,
					},
					{
						"summon" : "demonic_fledgling",
						"summon_position" : Vector2(0,-18),
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("DemonicWave_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", 0, 2, "nearest"),
				]
			}
		]
	},
	"demonic_fledgling" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(110,40), Vector2(30,10)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 500,
		"defense" : 10,
		"exp" : 100,
		"behavior" : 1,
		"speed" : 15,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("SmallDemonicBlast_weak_fast", 0, 0.2, "nearest"),
				]
			}
		]
	},
	"eye_of_naa'zorak" : {
		"scale" : 1.5,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,108), Vector2(36,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [0,1],
		},
		
		"health_scaling" : 30000,
		"health" : 10000,
		"defense" : 10,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : special_loot_pools["eye_of_naa'zorak"],
		"phases" : [
			{
				"duration" : 7,
				"health" : [66, 100],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", (360.0/8.0)*8, 0.5, "nearest"),
					
					MakeProjectile("DemonicWave_strong_medium", (360.0/6.0)*1, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/6.0)*2, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/6.0)*3, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/6.0)*4, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/6.0)*5, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/6.0)*6, 0.5, "nearest"),
					
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*1, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*2, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*3, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*4, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*5, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*6, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/7.0)*7, 0.5, "nearest"),
					
					MakeProjectile("GiantDemonicBlast_strong_slow", 10, 0, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_slow", -10, 0, "nearest"),
				]
			},
			{
				"duration" : 7,
				"health" : [66, 100],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*1, 0),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*2, 0),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*3, 0),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*4, 0),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*5, 0.5),
					
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*1, 0),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*2, 0),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*3, 0),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*4, 0),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*5, 0.5),
					
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*1, 0),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*2, 0),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*3, 0),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*4, 0),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*5, 0.5),
					
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*1, 0, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*2, 0, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*3, 0, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*4, 0, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_slow", (360.0/5.0)*5, 0.5, "nearest"),
					
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*1, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*2, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*3, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*4, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", (360.0/5.0)*5, 0.5, "nearest"),
					
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*1, 0, "nearest"),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*2, 0, "nearest"),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*3, 0, "nearest"),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*4, 0, "nearest"),
					MakeProjectile("SmallDemonicBlast_weak_fast", (360.0/5.0)*5, 0.5, "nearest"),
				] + CreateSpiral(2, "BloodSpinner_weak_fast", 0.1, null, 0.2, 16)
			},
			{
				"duration" : 5,
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 0,
				"health" : [66, 99.9999],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "You dare disrupt this ritual?..",
						"wait" : 3,
					},
					{
						"speech" : "BECOME A SACRIFICE!",
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/3.0)*1)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/3.0)*2)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/3.0)*3)*50,
						"wait" : 0,
					},
				]
			},
			{
				"duration" : 20,
				"health" : [66,100],
				"behavior" : 0,
				"on_signal" : ["monolith_active"],
				"on_spawn" : true,
				"attack_pattern" : CreateSpiral(4, "DemonicBlast_mid_slow", 0.3, null, 0.2, 32, true)
			},
			
			{
				"duration" : 7,
				"health" : [33, 66],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("Dart_strong_medium", -30, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", -20, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", -10, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", 0, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", 30, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", 20, 0, "nearest"),
					MakeProjectile("Dart_strong_medium", 10, 0.5, "nearest"),
					
					MakeProjectile("DemonicWave_mid_fast", -30, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast", -20, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast", -10, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast", 0, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast", 30, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast", 20, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast", 10, 1, "nearest"),
				] + CreateSpiral(1, "BloodSpinner_strong_medium", 0, null, 0.2, 20) + [MakeProjectile("None", -10, 0.3, "nearest")]
			},
			{
				"duration" : 7,
				"health" : [33, 66],
				"behavior" : 1,
				"attack_pattern" : [
					MakeProjectile("SmallDemonicBlast_mid_medium", -30, 0.1, "nearest"),
					MakeProjectile("SmallDemonicBlast_mid_medium", -20, 0.1, "nearest"),
					MakeProjectile("SmallDemonicBlast_mid_medium", -10, 0.1, "nearest"),
					MakeProjectile("SmallDemonicBlast_mid_medium", 0, 0.1, "nearest"),
					MakeProjectile("SmallDemonicBlast_mid_medium", 30, 0.1, "nearest"),
					MakeProjectile("SmallDemonicBlast_mid_medium", 20, 0.1, "nearest"),
					MakeProjectile("SmallDemonicBlast_mid_medium", 10, 0.1, "nearest"),
					
					MakeProjectile("DemonicBlast_strong_medium", 20, 0.2, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", 10, 0.2, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", 0, 0.2, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", -10, 0.2, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium", -20, 0.2, "nearest"),
					
					MakeProjectile("GiantDemonicBlast_strong_fast", -10, 0.3, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", 0, 0.3, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", 10, 0.3, "nearest"),
				] + CreateSpiral(1, "DemonicWave_mid_fast", 0, null, 0.2, 16) + [MakeProjectile("None", -10, 0.3, "nearest")] + CreateSpiral(1, "BloodSpinner_strong_medium", 0, null, 0.2, 7) + [MakeProjectile("None", -10, 0.3, "nearest")]
			},
			{
				"duration" : 5,
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 0,
				"health" : [33, 66],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "I EMBODY PURE EVIL...",
						"wait" : 3,
					},
					{
						"speech" : "KNOW SUFFERING!",
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/5.0)*1)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/5.0)*2)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/5.0)*3)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/5.0)*4)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/5.0)*5)*50,
						"wait" : 0,
					},
				]
			},
			{
				"duration" : 20,
				"health" : [33,66],
				"behavior" : 0,
				"on_signal" : ["monolith_active"],
				"on_spawn" : true,
				"attack_pattern" : CreateSpiral(5, "DemonicBlast_mid_slow", 0.3, "Dart_mid_medium", 0.2, 32, true)
			},
			
			{
				"duration" : 7,
				"health" : [0, 33],
				"behavior" : 2,
				"attack_pattern" : [
					MakeProjectile("GiantDemonicBlast_strong_fast", -20, 0.3, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", 20, 0.3, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", -40, 0.1, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", 40, 0.1, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", -60, 0.1, "nearest"),
					MakeProjectile("GiantDemonicBlast_strong_fast", 60, 0.1, "nearest"),
					
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*1, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*2, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*3, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*4, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*5, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*6, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*7, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*8, 0.5, "nearest"),
					
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*9, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*10, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*11, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*12, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*13, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*14, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*15, 0, "nearest"),
					MakeProjectile("DemonicWave_strong_medium", (360.0/16.0)*16, 0.5, "nearest"),
				] + CreateSpiral(1, "DemonicBlast_mid_slow", 0, null, 0.2, 24)
			},
			{
				"duration" : 5,
				"max_uses" : 1,
				"on_spawn" : true,
				"behavior" : 0,
				"health" : [0, 33],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "YOU FOOLS!..",
						"wait" : 3,
					},
					{
						"speech" : "RETURN TO THE ABYSS!",
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/6.0)*1)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/5.0)*2)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/6.0)*3)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/6.0)*4)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/6.0)*5)*50,
						"wait" : 0,
					},
					{
						"summon" : "demonic_monolith",
						"summon_position" : DegreesToVector((360.0/6.0)*6)*50,
						"wait" : 0,
					},
				]
			},
			{
				"duration" : 20,
				"health" : [0,33],
				"behavior" : 0,
				"on_signal" : ["monolith_active"],
				"on_spawn" : true,
				"attack_pattern" : CreateSpiral(6, "DemonicBlast_mid_slow", 0.4, "Dart_mid_medium", 0.3, 32, true)
			},
		]
	},
	"demonic_monolith" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,90), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 2000,
		"defense" : 1,
		"exp" : 200,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"signal" : "monolith_active",
						"reciever" : "eye_of_naa'zorak",
						"duration" : 1.6,
						"wait" : 0,
					},
					MakeProjectile("BloodSpinner_weak_fast_short", -40, 0, "nearest"),
					MakeProjectile("BloodSpinner_weak_fast_short", 40, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast_short", 0, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast_short", 10, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast_short", -10, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast_short", 20, 0, "nearest"),
					MakeProjectile("DemonicWave_mid_fast_short", -20, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium_short", 30, 0, "nearest"),
					MakeProjectile("DemonicBlast_strong_medium_short", -30, 1.5, "nearest"),
					
					{
						"signal" : "monolith_active",
						"reciever" : "eye_of_naa'zorak",
						"duration" : 1.6,
						"wait" : 0,
					},
				] + CreateSpiral(1, "Dart_strong_medium_short", 0, null, 0.2, 8) + [{"wait" : 1.5}]
			}
		]
	},
}
var halloween_island_enemies = {
	"pumpkin_tyrant" : {
		"scale" : 1.5,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(144,252), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"dungeon" : {
			"rate" : 0,
			"name" : "spooky_cavern"
		},
		
		"health_scaling" : 30000,
		"health" : 70000,
		"defense" : 1,
		"exp" : 2000,
		"behavior" : 0,
		"speed" : 10,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 1,
				"max_uses" : 1,
				"on_spawn" : true,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"summon" : "pumpkin_protector",
						"summon_position" : DegreesToVector(0)*100,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_protector",
						"summon_position" : DegreesToVector(180)*100,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 5,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0, 99.99],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 0,
					},
					{
						"speech" : "I am the spirit of halloween...",
						"wait" : 3,
					},
					{
						"speech" : "Let me show you a trick!",
						"wait" : 1,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(0)*30,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(240)*30,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(120)*30,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(0)*50,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(240)*50,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(120)*50,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 2,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0, 66],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 3,
						"wait" : 0,
					},
					{
						"speech" : "The pumpkin patch will rot your bones!",
						"wait" : 1,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(30)*20,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(240)*20,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(80)*20,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(0)*40,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(220)*40,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(130)*40,
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 2,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0, 33],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 3,
						"wait" : 0,
					},
					{
						"speech" : "My pumpkins are hungry!",
						"wait" : 1,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(0)*20,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(220)*20,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_fighter",
						"summon_position" : DegreesToVector(110)*20,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(0)*40,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(260)*40,
						"wait" : 0,
					},
					{
						"summon" : "pumpkin_minion",
						"summon_position" : DegreesToVector(100)*40,
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 1,
				"health" : [99.99,100],
				"attack_pattern" : [
					{
						"wait" : 1
					}
				]
			},
			{
				"duration" : 6,
				"health" : [33,99.99],
				"attack_pattern" : [
					MakeProjectile("PlatinumSlash_strong_fast", 15, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 5, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 0, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -5, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -15, 0.5, "nearest"),
					
					MakeProjectile("PlatinumSlash_strong_fast", 25, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 20, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 15, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 5, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 0, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -5, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -15, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -20, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -25, 1, "nearest"),
				]
			},
			{
				"duration" : 8,
				"health" : [33,99.99],
				"attack_pattern" : CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 12) + [{"wait" : 2}] + CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 16) + [{"wait" : 1.5}] + CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 20) + [{"wait" : 1}] + CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 30) + [{"wait" : 0.5}]
			},
			{
				"duration" : 15,
				"health" : [0,33],
				"behavior" : 2,
				"speed" : 5,
				"attack_pattern" : CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 12) + [{"wait" : 1}] + CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 16) + [{"wait" : 0.8}] + CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 20) + [{"wait" : 0.5}] + CreateSpiral(1, "PlatinumSlash_mid_medium", 0, null, 0.2, 30) + [{"wait" : 0.2}] + [
					MakeProjectile("PlatinumSlash_strong_fast", 15, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 5, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 0, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -5, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", -10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -15, 0.5, "nearest"),
					
					MakeProjectile("GiantBlast_medium", 25, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 15, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 5, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", 0, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", -5, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", -15, 0, "nearest"),
					MakeProjectile("GiantBlast_medium", -25, 1, "nearest"),
				]
			}
		]
	},
	"pumpkin_protector" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(180,252), Vector2(18,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"health" : 999999,
		"defense" : 0,
		"exp" : 10000,
		"anchor" : "parent",
		"behavior" : 3,
		"speed" : 30,
		"loot_pool" : basic_loot_pools["none"],
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"attack_pattern" : CreateSpiral(1,"Wave_mid_slow",0,null,0.2,8) + [{"wait" : 4}]
			},
		]
	},
	"pumpkin_fighter" : {
		"scale" : 1,
		"res" : 18,
		"height" : 12,
		"rect" : Rect2(Vector2(198,252), Vector2(18,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 1000,
		"defense" : 10,
		"exp" : 20,
		"behavior" : 1,
		"speed" : 20,
		"loot_pool" : special_loot_pools["pumpkin"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "PlatinumSlash",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 1,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
				]
			},
		]
	},
	"pumpkin_minion" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(0,250), Vector2(40,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 500,
		"defense" : 10,
		"exp" : 20,
		"anchor" : "parent",
		"behavior" : 3,
		"speed" : 6,
		"loot_pool" : special_loot_pools["pumpkin"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(5),
						"size" : medium
					},
					{
						"projectile" : "SmallBlast",
						"formula" : "0",
						"damage" : 50,
						"piercing" : false,
						"wait" : 1,
						"speed" : med,
						"tile_range" : 10,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-5),
						"size" : medium
					},
				]
			},
		]
	},
	"shadow_spider" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(0,252), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 1200,
		"defense" : 10,
		"exp" : 250,
		"behavior" : 2,
		"speed" : 10,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 65,
						"piercing" : true,
						"wait" : 0.8,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "Blast",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 0,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-10),
						"size" : medium
					},
					{
						"projectile" : "Wave",
						"formula" : "0",
						"damage" : 75,
						"piercing" : false,
						"wait" : 1,
						"speed" : med,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
				]
			},
		]
	},
	"greater_slime" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(54,252), Vector2(54,18)),
		"animations" : {
			"Idle" : [0,1],
			"Attack" : [2],
		},
		
		"health" : 2000,
		"defense" : 0,
		"exp" : 300,
		"behavior" : 2,
		"speed" : 6,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(60),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(40),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(20),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(0),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-60),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-40),
						"size" : medium
					},
					{
						"projectile" : "GreenBlast",
						"formula" : "0",
						"damage" : 90,
						"piercing" : false,
						"wait" : 0.3,
						"speed" : fast,
						"tile_range" : 8,
						"targeter" : "nearest",
						"direction" : DegreesToVector(-20),
						"size" : medium
					},
				]
			},
		]
	},
	"ghastly_ghoul" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(108,252), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health" : 1000,
		"defense" : 20,
		"exp" : 300,
		"behavior" : 2,
		"speed" : 20,
		"loot_pool" : basic_loot_pools["godlands_1"],
		"phases" : [
			{
				"duration" : 32,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*1, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*2, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*3, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*4, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*5, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*6, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*7, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", (360.0/8.0)*8, 3, "nearest"),
				]
			},
		]
	},
	
	"orbanis" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 10,
		"rect" : Rect2(Vector2(0,234), Vector2(36,18)),
		"custom_hitbox" : Vector2(11,10),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"no_sink" : true,
		"health_scaling" : 10000,
		"health" : 50000,
		"defense" : 0,
		"exp" : 5000,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 8,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0, 100],
				"attack_pattern" : [
					{
						"summon" : "orbanis_back",
						"summon_position" : Vector2(0, -15),
						"wait" : 0,
					},
					{
						"summon" : "orbanis_leg",
						"summon_position" : Vector2(29,12),
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "orbanis_leg",
						"summon_position" : Vector2(18,-2),
						"flip" : 0,
						"wait" : 0,
					},
					{
						"summon" : "orbanis_leg",
						"summon_position" : Vector2(-20,-2),
						"flip" : 1,
						"wait" : 0,
					},
					{
						"summon" : "orbanis_leg",
						"summon_position" : Vector2(-29,12),
						"flip" : 1,
						"wait" : 0,
					},
					
					{
						"effect" : "invincible",
						"duration" : 6,
						"wait" : 3,
					},
					{
						"speech" : "What a feast...",
						"wait" : 3,
					},
					{
						"speech" : "The pumpkin king has outdone himself this time!",
						"wait" : 1,
					},
					{
						"signal" : "initiate_legs",
						"reciever" : "orbanis_leg",
						"duration" : 1.1,
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 2,
				"health" : [70,100],
				"on_signal" : ["legs_alive"],
				"attack_pattern" : CreateSpiral(3, "AbyssBlast_strong_mid", 0.2, "BloodShuriken1", 0.2, 16, true)
			},
			{
				"duration" : 15,
				"health" : [70,100],
				"attack_pattern" : CreateSpiral(2, "AbyssBlast_strong_mid", 0.1, "AbyssSpinner_mid_fast", 0.2, 16, false) + CreateSpiral(2, "AbyssBlast_strong_mid", 0.1, "AbyssSpinner_mid_fast", 0.2, 16, false, true) + [
					{
						"wait" : 1,
					}
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					{
						"wait" : 1,
					}
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					{
						"wait" : 1,
					}
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					{
						"wait" : 1,
					}
				]
			},
			
			{
				"duration" : 2,
				"health" : [40,70],
				"on_signal" : ["legs_alive"],
				"attack_pattern" : [{ "effect" : "invincible", "duration" : 5, "wait" : 0 }] + CreateSpiral(1, "Wave_weak_fast", 0, null, 0, 32, true) + [{"wait":0.1}] + CreateSpiral(1, "Stack_strong_fast", 0, null, 0, 8, true) + CreateSpiral(1, "Wave_weak_fast", 0, null, 0, 32, true) + [{"wait":0.1}] + CreateSpiral(1, "Stack_strong_fast", 0, null, 0, 8, true) + CreateSpiral(1, "Wave_weak_fast", 0, null, 0, 32, true) + [{"wait":2}]
			},
			{
				"duration" : 15,
				"health" : [40,70],
				"attack_pattern" : CreateSpiral(2, "AbyssBlast_strong_mid", 0.1, "AbyssSpinner_mid_fast", 0.2, 24, false) + CreateSpiral(2, "AbyssBlast_strong_mid", 0.1, "AbyssSpinner_mid_fast", 0.2, 24, false, true) + [
					{
						"wait" : 0.5,
					}
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					{
						"wait" : 0.5,
					}
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					{
						"wait" : 0.5,
					}
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					{
						"wait" : 0.5,
					}
				]
			},
			{
				"duration" : 2,
				"health" : [40,70],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"speech" : "I will devour you myself!",
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : 3,
						"wait" : 0,
					},
					{
						"signal" : "initiate_legs",
						"reciever" : "orbanis_leg",
						"duration" : 1.1,
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 4,
				"health" : [10,40],
				"on_signal" : ["legs_alive"],
				"attack_pattern" : [{ "effect" : "invincible", "duration" : 5, "wait" : 0 }] + CreateSpiral(1, "Wave_weak_fast", 0, null, 0, 32, true) + [{"wait":0.1}] + CreateSpiral(1, "Stack_strong_fast", 0, null, 0, 8, true) + CreateSpiral(1, "Wave_weak_fast", 0, null, 0, 32, true) + [{"wait":0.1}] + CreateSpiral(1, "Stack_strong_fast", 0, null, 0, 8, true) + CreateSpiral(1, "Wave_weak_fast", 0, null, 0, 32, true) + [{"wait":2}]
			},
			{
				"duration" : 15,
				"health" : [10,40],
				"attack_pattern" : CreateSpiral(2, "AbyssBlast_strong_mid", 0.1, "AbyssSpinner_mid_fast", 1, 24, false) + CreateSpiral(2, "AbyssBlast_strong_mid", 0.1, "AbyssSpinner_strong_medium", 1, 24, false, true) + [
					MakeProjectile("GiantDemonicBlast_strong_slow", 6, 1, "nearest"),
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					MakeProjectile("GiantDemonicBlast_strong_slow", 6, 1, "nearest"),
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
					MakeProjectile("GiantDemonicBlast_strong_slow", 6, 1, "nearest"),
				] + CreateSpiral(1, "AbyssSpinner_mid_fast", 0, "BloodShuriken1", 1, 10, false) + [
				]
			},
			{
				"duration" : 2,
				"health" : [10,40],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"speech" : "Enough games, get caught in my web!",
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : 3,
						"wait" : 0,
					},
					{
						"signal" : "initiate_legs",
						"reciever" : "orbanis_leg",
						"duration" : 1.1,
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 2.5,
				"health" : [0,10],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"speech" : "Hissss! You win this time...",
						"wait" : 0,
					},
					{
						"effect" : "invincible",
						"duration" : 3,
						"wait" : 2,
					},
					{
						"summon" : "halloween_chest",
						"summon_position" : Vector2(0, 6*8),
						"wait" : 0,
					},
					{
						"dead" : true,
						"wait" : 1,
					}
				]
			},
			{
				"duration" : 2.5,
				"health" : [0,10],
				"attack_pattern" : [
					{
						"wait" : 1,
					}
					
				]
			},
		]
	},
	"orbanis_leg" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(36,234), Vector2(54,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
			"Death" : [2],
		},
		
		"no_sink" : true,
		"health_scaling" : 10000,
		"health" : 50000,
		"defense" : 0,
		"exp" : 0,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 1,
				"health" : [90,100],
				"on_spawn" : true,
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 0,
					},
					{
						"signal" : "legs_alive",
						"reciever" : "orbanis",
						"duration" : 1.1,
						"wait" : 1,
					},
				]
			},
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [90,100],
				"on_signal" : ["initiate_legs"],
				"attack_pattern" : [
					{
						"signal" : "legs_alive",
						"reciever" : "orbanis",
						"duration" : 1.1,
						"wait" : 1,
					},
				]
			},
			{
				"duration" : 1,
				"health" : [80,90],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 1,
					},
				]
			},
			
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [80,90],
				"on_signal" : ["initiate_legs"],
				"attack_pattern" : [
					{
						"dead" : false,
						"wait" : 0,
					},
					{
						"signal" : "legs_alive",
						"reciever" : "orbanis",
						"duration" : 1.1,
						"wait" : 1,
					},
				]
			},
			{
				"duration" : 1,
				"health" : [70,80],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 1,
					},
				]
			},
			
			{
				"duration" : OS.get_system_time_secs(),
				"health" : [70,80],
				"on_signal" : ["initiate_legs"],
				"attack_pattern" : [
					{
						"dead" : false,
						"wait" : 0,
					},
					{
						"signal" : "legs_alive",
						"reciever" : "orbanis",
						"duration" : 0.5,
						"wait" : 0,
					},
					MakeProjectile("Wave_weak_fast", 0, 0.4, "nearest"),
				]
			},
			{
				"duration" : 1,
				"health" : [60,70],
				"attack_pattern" : [
					{
						"dead" : true,
						"wait" : 1,
					},
				]
			},
		]
	},
	"orbanis_back" : {
		"scale" : 1.3,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,234), Vector2(18,18)),
		"custom_hitbox" : Vector2(0,0),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"no_sink" : true,
		"health" : OS.get_system_time_msecs(),
		"defense" : OS.get_system_time_msecs(),
		"exp" : 0,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : {
			"soulbound_loot" : [],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 1,
				"health" : [0,100],
				"attack_pattern" : [
					{
						"wait" : 1
					}
				]
			},
		]
	},
	
	"halloween_chest" : {
		"scale" : 1,
		"res" : 10,
		"height" : 8,
		"rect" : Rect2(Vector2(20,250), Vector2(10,10)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [],
		},
		
		"health_scaling" : 10000,
		"health" : 25000,
		"defense" : 0,
		"exp" : 500,
		"behavior" : 0,
		"speed" : 0,
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 107,
					"chance" : 100,
					"threshold" : 0.01,
				},
				{
					"item" : 13,
					"chance" : 1,
					"threshold" : 0.01,
				},
			],
			"loot" : [
				{
					"item" : 9,
					"chance" : 4,
				},
				{
					"item" : 10,
					"chance" : 4,
				},
				{
					"item" : 11,
					"chance" : 4,
				},
				{
					"item" : 12,
					"chance" : 4,
				},
			]
		},
		"phases" : [
			{
				"duration" : 3,
				"on_spawn" : true,
				"max_uses" : 1,
				"health" : [0, 100],
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 3,
						"wait" : 4
					}
				]
			},
			{
				"duration" : 3,
				"health" : [0, 100],
				"attack_pattern" : [
					{
						"wait" : 4
					}
				]
			}
		]
	}
}
var babel_bosses = {
	"argolath" : {
		"scale" : 1.5,
		"res" : 38,
		"height" : 22,
		"rect" : Rect2(Vector2(76,114), Vector2(152,38)),
		"animations" : {
			"Idle" : [1,2],
			"Attack" : [3,1],
		},
		
		"dungeon" : {
			"rate" : 1,
			"name" : "tower_of_babel_floor_2"
		},
		"loot_offset" : Vector2(0, 10),
		"health_scaling" : 50000,
		"health" : 75000,
		"defense" : 30,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 8,
		"loot_pool" : special_loot_pools["argolath"],
		"phases" : [
			{
				"duration" : 13,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 13,
						"wait" : 8,
					},
					{
						"speech" : "In the last thousand years...",
						"wait" : 2,
					},
					{
						"speech" : "This tower has stood as a reminder of Babel's power!..",
						"wait" : 2,
					},
					{
						"speech" : "Rest assured, it will not fall today.",
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,50],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "The power of Babel is beyond your understanding...",
						"wait" : 2,
					},
					{
						"speech" : "Know fear!",
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 4,
				"health" : [0,75],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"speech" : "My minions will drag you under!",
						"wait" : 2,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*1)*50,
						"wait" : 0,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*2)*50,
						"wait" : 0,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*3)*50,
						"wait" : 0,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*4)*50,
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,25],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"speech" : "My minions will drag you under!",
						"wait" : 2,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*1)*50,
						"wait" : 0,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*2)*50,
						"wait" : 0,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*3)*50,
						"wait" : 0,
					},
					{
						"summon" : "spawn_of_argolath",
						"summon_position" : DegreesToVector((360.0/4.0)*4)*50,
						"wait" : 3,
					},
				]
			},
			
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : CreateSpiral(1, "Blast_strong_fast", 0, null, 0.2, 16) + CreateSpiral(3, "GiantStack_strong_fast", 0.2, "GiantPlasmaSpinner_strong_mid", 0.3) + CreateSpiral(1, "Blast_strong_fast", 0, null, 0.2, 16) + CreateSpiral(3, "GiantStack_strong_fast", 0.2, "GiantPlasmaSpinner_strong_mid", 0.3, 32, false, true)
			},
			{
				"duration" : 10,
				"health" : [50,100],
				"attack_pattern" : CreateArc(32, 1, 16, "Plasma2_mid_fast", "nearest") + [{"wait" : 1}] + [
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.1, "nearest"),
					MakeProjectile("Plasma2_mid_fast", 20, 0.1, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", 40, 0.1, "nearest"),
					MakeProjectile("Plasma2_mid_fast", 60, 0.1, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", 40, 0.1, "nearest"),
					MakeProjectile("Plasma2_mid_fast", 20, 0.1, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.1, "nearest"),
					MakeProjectile("Plasma2_mid_fast", -20, 0.1, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", -40, 0.1, "nearest"),
					MakeProjectile("Plasma2_mid_fast", -60, 0.1, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", -40, 0.1, "nearest"),
					MakeProjectile("Plasma2_mid_fast", -20, 0.1, "nearest"),
				]
			},
			{
				"duration" : 1,
				"health" : [50,100],
				"max_uses" : 1,
				"attack_pattern" : [
					{
						"speech" : "Babel, lend me your power!",
						"wait" : 0,
					},
					{
						"summon" : "oracle_pillar_summon",
						"summon_position" : Vector2(8*6,7*8),
						"wait" : 0,
					},
					{
						"summon" : "oracle_pillar_summon",
						"summon_position" : Vector2(-8*6,7*8),
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/8*1), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/8*2), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/8*3), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/8*4), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/8*5), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/8*6), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/8*7), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/8*8), 0.5, "nearest"),
					
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/7*1), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/7*2), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/7*3), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/7*4), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/7*5), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/7*6), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/7*7), 0.5, "nearest"),
					
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/9*1), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/9*2), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/9*3), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/9*4), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/9*5), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/9*6), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/9*7), 0, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_mid", (360.0/9*8), 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", (360.0/9*9), 0.5, "nearest"),
					
				] + CreateSpiral(1, "PlasmaBall_mid_mid", 0, null, 0.2, 16) + CreateSpiral(1, "SmallPlasmaBall_mid_mid", 0, null, 0.2, 32) + [{"wait" : 1}]
			},
			{
				"duration" : 10,
				"health" : [0,50],
				"attack_pattern" : [
					MakeProjectile("Blast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -20, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -20, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -20, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -20, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -20, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", 20, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", -20, 0.2, "nearest"),
				] + CreateSpiral(1, "Slash_1", 0, null, 0, 9) + [{"wait" : 1}] + CreateSpiral(1, "GiantStack_strong_insane", 0, null, 0, 9) + [{"wait" : 0.2}] + CreateSpiral(1, "GiantStack_strong_insane", 0, null, 0, 9) + [{"wait" : 0.2}] + CreateSpiral(1, "GiantStack_strong_insane", 0, null, 0, 9) + [{"wait" : 0.6}] +  [
					MakeProjectile("Blast_strong_fast", -45, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", 45, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", -45, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", 45, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", -45, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", 45, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", -45, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", 45, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", -45, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", 45, 0.2, "nearest"),
					MakeProjectile("Blast_strong_fast", -45, 0, "nearest"),
					MakeProjectile("Blast_strong_fast", 45, 0.2, "nearest"),
				] + CreateSpiral(1, "Slash_1", 0, null, 0, 9) + [{"wait" : 1}] + CreateSpiral(1, "GiantStack_strong_insane", 0, null, 0, 9) + [{"wait" : 0.2}] + CreateSpiral(1, "GiantStack_strong_insane", 0, null, 0, 9) + [{"wait" : 0.2}] + CreateSpiral(1, "GiantStack_strong_insane", 0, null, 0, 9) + [{"wait" : 0.6}]
			},
		]
	},
	"spawn_of_argolath" : {
		"scale" : 1,
		"res" : 18,
		"height" : 16,
		"rect" : Rect2(Vector2(90,144), Vector2(36,18)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"loot_offset" : Vector2(0, 10),
		"health_scaling" : 2000,
		"health" : 2000,
		"defense" : 10,
		"exp" : 500,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : {
			"soulbound_loot" : [
				{
					"item" : 407,
					"chance" : 4000,
					"threshold" : 0.5,
				},
			],
			"loot" : []
		},
		"phases" : [
			{
				"duration" : 4,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 4,
						"wait" : 5,
					},
				]
			},
			{
				"duration" : 10,
				"health" : [0,100],
				"attack_pattern" : [
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.4, "parent"),
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.3, "parent"),
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.2, "parent"),
					MakeProjectile("SmallPlasmaBall_mid_mid", 0, 0.2, "nearest"),
					MakeProjectile("SmallPlasmaBall_mid_mid", 0, 0.1, "nearest"),
					MakeProjectile("SmallPlasmaBall_mid_mid", 0, 0.5, "nearest"),
				]
			},
		]
	},
	
	"babel" : {
		"scale" : 1,
		"res" : 38,
		"height" : 16,
		"rect" : Rect2(Vector2(0,114), Vector2(76,38)),
		"animations" : {
			"Idle" : [0],
			"Attack" : [1],
		},
		
		"health_scaling" : 60000,
		"health" : 100000,
		"defense" : 0,
		"exp" : 1000,
		"behavior" : 1,
		"speed" : 5,
		"loot_pool" : special_loot_pools["babel"],
		"phases" : [
			{
				"duration" : 16,
				"health" : [0,100],
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 13,
						"wait" : 8,
					},
					{
						"speech" : "Ah, you managed to climb up here...",
						"wait" : 3,
					},
					{
						"speech" : "I was once like you, a spry young adventurer looking for battle...",
						"wait" : 3,
					},
					{
						"speech" : "See if you can keep up!",
						"wait" : 3,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,66],
				"behavior" : 0,
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "You sure are strong...",
						"wait" : 2,
					},
					{
						"speech" : "But I am only getting started!",
						"wait" : 2,
					},
				]
			},
			{
				"duration" : 4,
				"health" : [0,33],
				"behavior" : 0,
				"max_uses" : 1,
				"on_spawn" : true,
				"attack_pattern" : [
					{
						"effect" : "invincible",
						"duration" : 5,
						"wait" : 1,
					},
					{
						"speech" : "In this world, where kingdoms rise and fall...",
						"wait" : 2,
					},
					{
						"speech" : "My tower has stood for a millenium!",
						"wait" : 2,
					},
				]
			},
			
			{
				"duration" : 6,
				"health" : [66,100],
				"behavior" : 1,
				"speed" : 35,
				"attack_pattern" : CreateSpiral(3, "Plasma2_mid_fast", 0.2, "PlasmaBall_mid_mid", 0.3, 16) + CreateSpiral(3, "Plasma2_mid_fast", 0.2, "PlasmaBall_mid_mid", 0.3, 16, false, true)
			},
			{
				"duration" : 6,
				"health" : [66,100],
				"behavior" : 2,
				"speed" : 25,
				"attack_pattern" : [
					MakeProjectile("Stack_strong_medium", 15, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 0, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", -15, 0.4, "nearest"),
					
					MakeProjectile("PlatinumSlash_strong_fast", 50, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", 35, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 20, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -20, 0, "nearest"),
					MakeProjectile("Stack_strong_medium", -35, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -50, 0.5, "nearest"),
				] + CreateSpiral(4, "Plasma2_mid_fast", 0.2, null, 0.2, 8)
			},
			{
				"duration" : 6,
				"health" : [66,100],
				"behavior" : 2,
				"speed" : 30,
				"attack_pattern" : [
					MakeProjectile("GiantPlasmaSpinner_strong_mid", 15, 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", 0, 0, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", -15, 0.4, "nearest"),
				] + CreateSpiral(3, "Plasma2_mid_fast", 0.2, null, 0.2, 7)
			},
			
			{
				"duration" : 6,
				"health" : [33,66],
				"behavior" : 2,
				"speed" : 25,
				"attack_pattern" : [
					MakeProjectile("PlatinumSlash_strong_fast", 10, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 5, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -5, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -10, 0.2, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", 25, 0, "nearest"),
					MakeProjectile("PlatinumSlash_strong_fast", -25, 0, "nearest"),
				] + CreateSpiral(1, "GiantPlasmaSpinner_strong_mid", 0, null, 0.2, 8) + CreateSpiral(1, "PlasmaSpinner_mid_fast", 0, null, 0.2, 12) + [{"wait" : 1.5}]
			},
			{
				"duration" : 6,
				"health" : [33,66],
				"behavior" : 1,
				"speed" : 35,
				"attack_pattern" : [
					MakeProjectile("GiantPlasmaSpinner_strong_mid", 0, 0.2, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("GiantPlasmaSpinner_strong_mid", 0, 0.2, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("PlasmaBall_mid_mid", 0, 0.2, "nearest"),
					MakeProjectile("PlasmaSpinner_mid_fast", 0, 0.2, "nearest"),
					MakeProjectile("PlasmaBall_mid_mid", 0, 0.2, "nearest"),
				] + CreateSpiral(1, "GiantPlasmaSpinner_strong_mid", 0, null, 0.2, 7) + CreateSpiral(1, "PlasmaSpinner_mid_fast", 0, null, 0.2, 16) + [{"wait" : 1}]
			},
			
			{
				"duration" : 5,
				"behavior" : 2,
				"speed" : 20,
				"health" : [0,33],
				"attack_pattern" : CreateSpiral(7, "PlatinumSlash_strong_fast", 0.2, null, 0.2, 7) + CreateArc(16, 1, 8, "GiantPlasmaSpinner_strong_mid", "nearest") + CreateSpiral(6, "PlatinumSlash_strong_fast", 0.2, null, 0.2, 6) + CreateArc(32, 17, 32, "GiantPlasmaSpinner_strong_mid", "nearest")
			},
			{
				"duration" : 5,
				"behavior" : 1,
				"speed" : 5,
				"health" : [0,33],
				"attack_pattern" : [
					{
						"summon" : "fireball",
						"summon_position" : Vector2(-8*5,0),
						"wait" : 3,
					},
				] + CreateSpiral(4, "Plasma2_mid_fast", 0.1, null, 0.2, 8) + CreateArc(16, 1, 8, "GiantPlasmaSpinner_strong_mid", "nearest") + CreateSpiral(3, "Plasma2_mid_fast", 0.1, null, 0.2, 7) + CreateArc(16, 9, 16, "GiantPlasmaSpinner_strong_mid", "nearest")
			},
		]
	},
}

onready var enemies = CompileEnemies()
func CompileEnemies():
	var res = {}
	res.merge(babel_bosses)
	res.merge(misc)
	res.merge(rulers)
	res.merge(tutorial_enemies)
	res.merge(realm_enemies)
	res.merge(orc_vigil_enemies)
	res.merge(frozen_fortress_enemies)
	res.merge(desert_catacombs_enemies)
	res.merge(the_abyss_enemies)
	res.merge(ruined_temple_enemies)
	res.merge(rocky_cave_enemies)
	res.merge(cloud_isles_enemies)
	res.merge(halloween_island_enemies)
	return res

var dungeons = {
	"tutorial_entrance" : {
		"difficulty" : "Easy",
		"group_size" : "1",
		"portal_rect" : [0,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "nature_druid",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			4 : "tutorial_crab",
			5 : "tutorial_nature_druid",
		}
	},
	"tutorial" : {
		"difficulty" : "Easy",
		"group_size" : "1",
		"portal_rect" : [0,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "tutorial_troll_king",
		"room_size" : 100,
		"spawnpoint" : Vector2(19,-5)*8,
		"tile_translation" : {
			9 : "crab",
			10 : "slime",
			11 : "goblin_cannon",
			12 : "tutorial_troll_king",
		}
	},
	"tower_of_babel_floor_1" : {
		"difficulty" : "Hard",
		"group_size" : "1-10",
		"portal_rect" : [10,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "argolath",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			8 : "argolath",
		}
	},
	"tower_of_babel_floor_2" : {
		"difficulty" : "Hard",
		"group_size" : "1-10",
		"portal_rect" : [10,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "babel",
		"room_size" : 100,
		"spawnpoint" : Vector2(16,22)*8,
		"tile_translation" : {
			8 : "babel",
		}
	},
	"island" : {
		"difficulty" : "NA",
		"dungeon_boss" : "salazar",
		"portal_rect" : [0,0,"objects_16x16"],
		"enemies" : [realm_enemies, rulers]
	},
	"orc_vigil" : {
		"difficulty" : "Medium",
		"group_size" : "1-10",
		"portal_rect" : [10,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "vigil_guardian",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			5 : "vigil_guardian",
			6 : "orc_monolith",
		}
	},
	"orc_vigil_sanctum" : {
		"difficulty" : "Hard",
		"group_size" : "5-20",
		"portal_rect" : [20,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "atlas",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			5 : "atlas",
			6 : "orc_monolith",
		}
	},
	"the_abyss" : {
		"difficulty" : "Hard",
		"group_size" : "5-20",
		"portal_rect" : [90,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "salazar,_rex_of_the_abyss",
		"room_size" : 100,
		"spawnpoint" : Vector2(10,10)*8,
		"tile_translation" : {
			7 : "salazar,_rex_of_the_abyss",
		}
	},
	"frozen_fortress" : {
		"difficulty" : "Hard",
		"group_size" : "5-20",
		"portal_rect" : [30,0,"objects_8x8"],
		"type" : "procedural",
		"dungeon_boss" : "frozen_monolith",
		"basic_rooms" : ["Room1","Room2"],
		"rooms_until_boss" : 1,
		"room_size" : 26,
		"tile_translation" : {
			6 : "frozen_monolith",
			7 : "og_the_treacherous",
			8 : "ice_golem",
			9 : "ice_troll_guardian",
			10 : "ice_demon",
		}
	},
	"cloud_isles" : {
		"difficulty" : "Medium",
		"group_size" : "1-10",
		"portal_rect" : [80,0,"objects_8x8"],
		"type" : "procedural",
		"dungeon_boss" : "pohaku",
		"basic_rooms" : ["Room1","Room2","Room3"],
		"rooms_until_boss" : 3,
		"room_size" : 26,
		"tile_translation" : {
			7 : "pohaku",
			8 : "blue_basalisk",
			9 : "giant_vermin",
			10 : "gold_guardian",
			11 : "cloud_sprite",
		}
	},
	"desert_catacombs" : {
		"difficulty" : "Medium",
		"group_size" : "1-10",
		"portal_rect" : [40,0,"objects_8x8"],
		"type" : "procedural",
		"dungeon_boss" : "mummified_king",
		"basic_rooms" : ["Room1", "Room2", "Room3"],
		"rooms_until_boss" : 5,
		"room_size" : 21,
		"tile_translation" : {
			4 : "mummified_spider",
			5 : "sand_golem",
			6 : "mummified_ghoul",
			7 : "mummified_king",
		}
	},
	"rocky_cave" : {
		"difficulty" : "Easy",
		"group_size" : "1-3",
		"portal_rect" : [60,0,"objects_8x8"],
		"type" : "procedural",
		"dungeon_boss" : "rokk_the_rough",
		"basic_rooms" : ["Room1", "Room2", "Room3"],
		"rooms_until_boss" : 4,
		"room_size" : 21,
		"tile_translation" : {
			4 : "rokk_the_rough",
			5 : "lil_rock_golem",
			6 : "rock_sprite",
			7 : "rock_scorpion",
		}
	},
	"ruined_temple" : {
		"difficulty" : "Hard",
		"group_size" : "5-20",
		"portal_rect" : [50,0,"objects_8x8"],
		"type" : "procedural",
		"dungeon_boss" : "eye_of_naa'zorak",
		"basic_rooms" : ["Room1", "Room2", "Room3"],
		"rooms_until_boss" : 3,
		"room_size" : 24,
		"tile_translation" : {
			6 : "demonic_beast",
			7 : "demonic_spirit",
			8 : "imp_general",
			9 : "eye_of_naa'zorak",
		}
	},
	"goblin_cellar" : {
		"type" : "procedural",
		"dungeon_boss" : "gobby",
		"basic_rooms" : ["Room1", "Room2"],
		"rooms_until_boss" : 5,
		"room_size" : 21,
		"tile_translation" : {
			4 : "crab",
		}
	},
	
	"test_dungeon" : {
		"type" : "encounter",
		"room_size" : 100,
		"spawnpoint" : Vector2(0,0),
		"tile_translation" : {
		}
	},
	"spooky_cavern" : {
		"difficulty" : "Medium",
		"group_size" : "1-10",
		"portal_rect" : [100,0,"objects_8x8"],
		"type" : "encounter",
		"dungeon_boss" : "orbanis",
		"room_size" : 40,
		"spawnpoint" : Vector2(14,10)*8,
		"tile_translation" : {
			5 : "orbanis",
		}
	},
}

var items = {
	-2 : {
		"name": "Ascension Shard",
		"description" : "A precious gem, what will it awaken in you?",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "ascend 1",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,13)],
	},
	-1 : {
		"name": "Ascension Stone",
		"description" : "A precious gem, what will it awaken in you?",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "ascend 2",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,13)],
	},
	0 : {
		"name": "Ascension Gemstone",
		"description" : "A precious gem, what will it awaken in you?",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "ascend 3",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,13)],
	},
	1 : {
		"name": "Timber",
		"description" : "A few logs, can be used to build (/home)",
		"tier" : "5",
		"type" : "Material",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,13)],
	},
	2 : {
		"name": "Stones",
		"description" : "A few stones, can be used to build (/home)",
		"tier" : "5",
		"type" : "Material",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,13)],
	},
	3 : {
		"name": "Opal",
		"description" : "A rare opal gemstone, can be used to build (/home)",
		"tier" : "5",
		"type" : "Material",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(5,13)],
	},
	4 : {
		"name": "Gold Idol",
		"description" : "A rare treasure, look but don't touch",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 0.5, "range" : 16},
		},
		"stats" : {
			"vitality" : 15,
		},
		"tier" : "5",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,13)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	5 : {
		"name": "Gold Idol",
		"description" : "A rare treasure, look but don't touch",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"berserk" : { "duration" : 0.5, "range" : 16},
		},
		"stats" : {
			"dexterity" : 15,
		},
		"tier" : "5",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,13)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	6 : {
		"name": "Gold Idol",
		"description" : "A rare treasure, look but don't touch",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 20,
		"buffs" : {
			"invincible" : { "duration" : 0.5, "range" : 16},
		},
		"stats" : {
			"health" : 100,
		},
		"tier" : "5",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,13)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	7 : {
		"name": "Gold Flask",
		"description" : "A rare treasure, look but don't touch",
		"tier" : "5",
		"type" : "Material",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,13)],
	},
	8 : {
		"name": "Gold Coin",
		"description" : "A rare treasure, look but don't touch",
		"tier" : "5",
		"type" : "Material",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(8,13)],
	},
	9 : {
		"name": "Orange Candy",
		"description" : "A tasty treat, +100 attack for 1 minute",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "buff attack 100 60",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,14)],
	},
	10 : {
		"name": "Yellow Candy",
		"description" : "A tasty treat, +100 speed for 1 minute",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "buff speed 100 60",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,14)],
	},
	11 : {
		"name": "Green Candy",
		"description" : "A tasty treat, +100 attack speed for 1 minute",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "buff dexterity 100 60",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,14)],
	},
	12 : {
		"name": "Pink Candy",
		"description" : "A tasty treat, +500 regen for 1 minute",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "buff vitality 500 60",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,14)],
	},
	13 : {
		"name": "Treat Basket",
		"description" : "What might you find inside?",
		"tier" : "5",
		"type" : "Consumable",
		"use" : "gift halloween",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,14)],
	},
	14 : {
		"name": "Blue Tuna",
		"description" : "I think a certain fisherman was looking for this...",
		"tier" : "5",
		"type" : "Sword",
		"slot" : "weapon",
		"use" : "open tundra",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [15,25],
				"projectile" : "TunaSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(210.0, 238.0, 255.0),
			"weaponNew" : RgbToColor(70.0, 186.0, 255.0),
		},
		"textures" : {},
		"path" : ["items/items_8x8.png", 26, 26, Vector2(9,13)],
	},
	15 : {
		"name": "Blackened Key",
		"description" : "What lies in the bottom of the tower...",
		"tier" : "5",
		"type" : "Material",
		"slot" : "na",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(10,13)],
	},
	100 : {
		"name": "Short Sword",
		"description" : "A simple yet effective weapon.",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [15,25],
				"projectile" : "IronSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {}
	},
	101 : {
		"name": "Gold Sword",
		"description" : "A sword that is equally as effective as it is flashy",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "1",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [25,35],
				"projectile" : "GoldSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(231.0, 211.0, 61.0)
		},
		"textures" : {}
	},
	102 : {
		"name": "Platinum Sword",
		"description" : "A razor sharp blade made from a precious metal",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [40,55],
				"projectile" : "PlatinumSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,0)],
		"colors" : {
			"weaponSecondaryNew" : Color("c6b078"),
			"weaponNew" : Color("d8d8d8"),
		},
		"textures" : {}
	},
	103 : {
		"name": "Mithril Sword",
		"description" : "A sword made from an impossibly light and durable blue metal",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "3",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [65,90],
				"projectile" : "MithrilSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(231.0, 211.0, 61.0),
			"weaponNew" : RgbToColor(25.0, 182.0, 182.0)
		},
		"textures" : {}
	},
	104 : {
		"name": "Rexium Sword",
		"description" : "A sword capable of slicing worlds",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 100,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [80,110],
				"projectile" : "RedRexiumSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 3,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(231.0, 211.0, 61.0),
			"weaponNew" :RgbToColor(153.0, 3.0, 19.0),
		},
		"textures" : {}
	},
	105 : {
		"name": "Hellrazor",
		"description" : "No tree, it is said, can grow to heaven unless its roots reach down to hell",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 80,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [40,50],
				"projectile" : "BattleaxeSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 4,
				"size" : 4,
				"offset" : DegreesToVector(15),
			},
			{
				"damage" : [40,50],
				"projectile" : "BattleaxeSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 4,
				"size" : 4,
				"offset" : DegreesToVector(5),
			},
			{
				"damage" : [40,50],
				"projectile" : "BattleaxeSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 4,
				"size" : 4,
				"offset" : DegreesToVector(-5),
			},
			{
				"damage" : [40,50],
				"projectile" : "BattleaxeSlash",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 4,
				"size" : 4,
				"offset" : DegreesToVector(-15),
			},
			
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,0)],
		"colors" : {
			"weaponSecondaryNew" : Color("b88b06"),
			"weaponNew" : RgbToColor(134.0, 2.0, 141.0)
		},
		"textures" : {
			"weaponTexture" : "warlord's_battleaxe"
		}
	},
	106 : {
		"name": "Ice Scimitar",
		"description" : "A scimitar forgotten in the frozen fortress long ago",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 200,
		"stats" : {},
		
		"projectiles" : [
			{
				"damage" : [60,70],
				"projectile" : "IceSlash",
				"formula" : "sin(x)",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 2,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,0)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(0.0, 0.0, 0.0),
			"weaponNew" : RgbToColor(0.0, 0.0, 0.0)
		},
		"textures" : {
			"weaponTexture" : "ice_scimitar"
		}
	},
	107 : {
		"name": "Spider Fang",
		"description" : "A vicious mandible from a scary night",
		"type" : "Sword",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 100,
		"stats" : {
			"vitality" : 100,
		},
		
		"projectiles" : [
			{
				"damage" : [50,60],
				"projectile" : "BloodSlash",
				"formula" : "-sin(x)",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 4,
				"size" : 5,
				"offset" : DegreesToVector(10),
			},
			{
				"damage" : [50,60],
				"projectile" : "BloodSlash",
				"formula" : "sin(x)",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 4,
				"size" : 5,
				"offset" : DegreesToVector(-10),
			},
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,14)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(209.0, 198.0, 202.0),
			"weaponNew" : RgbToColor(222.0, 0.0, 0.0)
		},
		"textures" : {
		}
	},
	
	133 : {
		"name": "Wand of Fire",
		"description" : "A wooden wand with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 150,
		"stats" : {
		
		},
		"projectiles" : [
			{
				"damage" : [10,15],
				"projectile" : "Fire1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(9,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(160.0, 18.0, 0.0)
		},
		"textures" : {
		}
	},
	134 : {
		"name": "Staff of Fire",
		"description" : "A golden staff with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 150,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [25,30],
				"projectile" : "Fire2",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(10,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(160.0, 18.0, 0.0)
		},
		"textures" : {
		}
	},
	135 : {
		"name": "Sceptre of Fire",
		"description" : "A powerful sceptre with a fire spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 150,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [50,60],
				"projectile" : "Fire3",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 7,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(11,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(160.0, 18.0, 0.0)
		},
		"textures" : {
		}
	},
	136 : {
		"name": "Wand of Nature",
		"description" : "A wooden wand with a nature spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 100,
		"stats" : {
		
		},
		"projectiles" : [
			{
				"damage" : [10,15],
				"projectile" : "Nature1",
				"formula" : "sin(x)",
				"piercing" : true,
				"speed" : med,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(9,4)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(62.0, 187.0, 96.0)
		},
		"textures" : {
		}
	},
	137 : {
		"name": "Staff of Nature",
		"description" : "A golden staff with a nature spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 60,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [30,40],
				"projectile" : "Nature2",
				"formula" : "sin(x)",
				"piercing" : true,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 4,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [20,30],
				"projectile" : "Nature1",
				"formula" : "sin(x)",
				"piercing" : true,
				"speed" : med,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(10,4)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(62.0, 187.0, 96.0)
		},
		"textures" : {
		}
	},
	138 : {
		"name": "Sceptre of Nature",
		"description" : "A powerful sceptre with a nature spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 40,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [50,60],
				"projectile" : "Nature3",
				"formula" : "sin(x)",
				"piercing" : true,
				"speed" : 90,
				"tile_range" : 7,
				"size" : small,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [40,50],
				"projectile" : "Nature2",
				"formula" : "sin(x)",
				"piercing" : true,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 4,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [30,40],
				"projectile" : "Nature1",
				"formula" : "sin(x)",
				"piercing" : true,
				"speed" : med,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(11,4)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(62.0, 187.0, 96.0)
		},
		"textures" : {
		}
	},
	139 : {
		"name": "Wand of Water",
		"description" : "A wooden wand with a water spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 100,
		"stats" : {
		
		},
		"projectiles" : [
			{
				"damage" : [5,10],
				"projectile" : "Water1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(10),
			},
			{
				"damage" : [5,10],
				"projectile" : "Water1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(-10),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(9,5)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(25.0, 182.0, 182.0)
		},
		"textures" : {
		}
	},
	140 : {
		"name": "Staff of Water",
		"description" : "A golden staff with a water spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 100,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [10,20],
				"projectile" : "Water1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(20),
			},
			{
				"damage" : [20,30],
				"projectile" : "Water2",
				"formula" : "0",
				"piercing" : false,
				"speed" : 110,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [10,20],
				"projectile" : "Water1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(-20),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(10,5)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(25.0, 182.0, 182.0)
		},
		"textures" : {
		}
	},
	141 : {
		"name": "Sceptre of Water",
		"description" : "A powerful sceptre with a water spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 100,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [10,20],
				"projectile" : "Water1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(-40),
			},
			{
				"damage" : [20,30],
				"projectile" : "Water2",
				"formula" : "0",
				"piercing" : false,
				"speed" : 110,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(-20),
			},
			{
				"damage" : [40,50],
				"projectile" : "Water3",
				"formula" : "0",
				"piercing" : false,
				"speed" : 120,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [20,30],
				"projectile" : "Water2",
				"formula" : "0",
				"piercing" : false,
				"speed" : 110,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(20),
			},
			{
				"damage" : [10,20],
				"projectile" : "Water1",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector(40),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(11,5)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(25.0, 182.0, 182.0)
		},
		"textures" : {
		}
	},
	142 : {
		"name": "Flamespitter",
		"description" : "An ancient staff, a burning reminder of Salazar's fury",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 75,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [80,100],
				"projectile" : "Fire3",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset_variation" : 10,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [40,65],
				"projectile" : "Fire2",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 5,
				"size" : 3,
				"offset_variation" : 30,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [20,30],
				"projectile" : "Fire1",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 5,
				"size" : 3,
				"offset_variation" : 45,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [20,30],
				"projectile" : "Fire1",
				"formula" : "0",
				"piercing" : false,
				"speed" : med,
				"tile_range" : 5,
				"size" : 3,
				"offset_variation" : 45,
				"offset" : DegreesToVector(0),
			},
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(12,3)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(160.0, 18.0, 0.0)
		},
		"textures" : {
			"weaponTexture" : "flamespitter"
		}
	},
	143 : {
		"name": "Hj'ek Naga",
		"description" : "A wand used to ward of the giant Naga of the cloud islands.",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 63,
		"stats" : {
			"health" : 400
		},
		
		"projectiles" : [
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*1),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*2),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*3),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*4),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*5),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*6),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*7),
			},
			{
				"damage" : [50,60],
				"projectile" : "GreenBlast",
				"formula" : "0",
				"piercing" : false,
				"speed" : fast,
				"tile_range" : 6,
				"size" : 3,
				"offset" : DegreesToVector((360.0/8.0)*8),
			},
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(12,4)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(88.0, 85.0, 18.0)
		},
		"textures" : {
			"weaponTexture" : "h'jek_naga"
		}
	},
	144 : {
		"name": "Sceptre of The Void",
		"description" : "A powerful sceptre with a dark spell",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "5",
		
		"rof" : 13,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [400,500],
				"projectile" : "GiantVoid",
				"formula" : "0",
				"piercing" : true,
				"speed" : 20,
				"tile_range" : 7,
				"size" : 7,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(11,6)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(232.0, 210.0, 65.0),
			"weaponNew" : RgbToColor(154.0, 35.0, 193.0)
		},
		"textures" : {
		}
	},
	145 : {
		"name": "Soulflame Sceptre",
		"description" : "A powerful sceptre, lit by the souls of the fallen",
		"type" : "Staff",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 200,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [39,40],
				"projectile" : "PlasmaFlipped",
				"formula" : "sin(x+3.14)",
				"piercing" : false,
				"speed" : 40,
				"tile_range" : 9,
				"size" : 7,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [39,40],
				"projectile" : "Plasma1",
				"formula" : "sin(x)",
				"piercing" : false,
				"speed" : 40,
				"tile_range" : 9,
				"size" : 7,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(12,5)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(0.0, 0.0, 0.0)
		},
		"textures" : {
			"weaponTexture" : "soulflame_sceptre"
		}
	},
	166 : {
		"name": "Wooden Bow",
		"description" : "A flimsy excuse for a bow.",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "0",
		
		"rof" : 100,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [15,20],
				"projectile" : "SteelArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(174.0, 172.0, 156.0)
		},
		"textures" : {
		}
	},
	167: {
		"name": "Yew Bow",
		"description" : "A reminder of simple times.",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "1",
		
		"rof" : 100,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [15,20],
				"projectile" : "GoldenArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(-7.5),
			},
			{
				"damage" : [15,20],
				"projectile" : "GoldenArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(7.5),
			},
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(207.0, 189.0, 56.0)
		},
		"textures" : {
		}
	},
	168: {
		"name": "Magical Bow",
		"description" : "A bow enhanced with a powerful spell.",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "2",
		
		"rof" : 100,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [25,30],
				"projectile" : "MagicArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(7.5),
			},
			{
				"damage" : [25,30],
				"projectile" : "MagicArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(-7.5),
			},
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(161.0, 87.0, 8.0),
			"weaponNew" : RgbToColor(28.0, 201.0, 201.0)
		},
		"textures" : {
		}
	},
	169: {
		"name": "Bloodstone Bow",
		"description" : "A strange bow crafted on a blood moon.",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "3",
		
		"rof" : 100,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [30,35],
				"projectile" : "BloodArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [30,35],
				"projectile" : "BloodArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(-15),
			},
			{
				"damage" : [30,35],
				"projectile" : "BloodArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(15),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(150.0, 93.0, 0.0),
			"weaponNew" : RgbToColor(160.0, 0.0, 0.0)
		},
		"textures" : {
		}
	},
	170 : {
		"name": "Shadowbringer Bow",
		"description" : "A powerful weapon carved from a shadow tree.",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "4",
		
		"rof" : 100,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [45,50],
				"projectile" : "ShadowArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(-15),
			},
			{
				"damage" : [55,60],
				"projectile" : "GiantShadowArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(0),
			},
			{
				"damage" : [45,50],
				"projectile" : "ShadowArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 75,
				"tile_range" : 5,
				"size" : 3,
				"offset" : DegreesToVector(15),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(105.0, 51.0, 10.0),
			"weaponNew" : RgbToColor(153.0, 35.0, 193.0)
		},
		"textures" : {
		}
	},
	171 : {
		"name": "Archaic Crossbow",
		"description" : "A deadly crossbow from the old orc empire.",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 50,
		"stats" : {
					
		},
		
		"projectiles" : [
			{
				"damage" : [250,300],
				"projectile" : "ArchaicArrow",
				"formula" : "0",
				"piercing" : true,
				"speed" : 50,
				"tile_range" : 7,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(132.0, 124.0, 94.0),
		},
		"textures" : {
			"weaponTexture" : "archaic_crossbow"
		}
	},
	172 : {
		"name": "Goblin Cannon",
		"description" : "Some goblin tech that goes off with a BANG!",
		"type" : "Bow",
		"slot" : "weapon",
		"tier" : "UT",
		
		"rof" : 10,
		"stats" : {
		
		},
		
		"projectiles" : [
			{
				"damage" : [500,700],
				"projectile" : "CannonBall",
				"formula" : "0",
				"piercing" : false,
				"speed" : 100,
				"tile_range" : 5,
				"size" : 4,
				"offset" : DegreesToVector(0),
			}
		],
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,2)],
		"colors" : {
			"weaponSecondaryNew" : RgbToColor(0.0, 0.0, 0.0),
			"weaponNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
		}
	},
	500 : {
		"name": "Iron Platebody",
		"description" : "A beginner warriors only protection from death",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"defense" : 6
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(157.0, 153.0, 135.0),
			"bodyLightNew" : RgbToColor(174.0, 172.0, 156.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	501 : {
		"name": "Gold Platebody",
		"description" : "A regal platebody for a strong warrior",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"defense" : 8
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"bodyLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	502 : {
		"name": "Platinum Platebody",
		"description" : "A premium armor made from a premium metal",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"defense" : 12
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,4)],
		"colors" : {
			"bandNew" : Color("c6b078"),
			"bodyLightNew" : Color("d8d8d8"),
			"bodyMediumNew" : Color("b5b5b5"),
		},
		"textures" : {
			
		}
	},
	503 : {
		"name": "Mithril Platebody",
		"description" : "An armor capable of deflecting fearsome blows",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"defense" : 16
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(20.0, 140.0, 140.0),
			"bodyLightNew" : RgbToColor(23.0, 163.0, 163.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	504 : {
		"name": "Rexium Platebody",
		"description" : "A magic alloy forms the strongest armor imaginable",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"defense" : 20
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(125.0, 26.0, 22.0),
			"bodyLightNew" : RgbToColor(153.0, 3.0, 19.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			
		}
	},
	505 : {
		"name": "Bedrock Platebody",
		"description" : "A ridiculously durable armor taken from the lowest parts of the rocky caves",
		"type" : "Armor",
		"slot" : "armor",
		"tier" : "UT",
		
		"stats" : {
			"defense" : 14,
			"vitality" : 5,
			"health" : 100
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,4)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(90.0, 16.0, 82.0),
			"bodyLightNew" : RgbToColor(108.0, 2.0, 113.0),
			"bandNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			"bodyTexture" : "bedrock_platebody",
		}
	},
	533 : {
		"name": "Worn Robe",
		"description" : "A flimsy robe",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"defense" : 1,
			"attack" : 1
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(105, 51.0, 10.0),
			"bodyLightNew" : RgbToColor(123.0, 72.0, 17.0),
			"bandNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	534 : {
		"name": "Leather Robe",
		"description" : "a fine leather robe",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"defense" : 2,
			"attack" : 2
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(161.0, 87.0, 8.0),
			"bodyLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"bandNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	535 : {
		"name": "Magic Robe",
		"description" : "a wizard's robe imbued with a magic spell",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"defense" : 3,
			"attack" : 4
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(225.0, 222.0, 213.0),
		},
		"textures" : {
			
		}
	},
	536 : {
		"name": "Sunflare Robe",
		"description" : "A powerful robe, hot to the touch",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"defense" : 5,
			"attack" : 7
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"bodyLightNew" : RgbToColor(232.0, 211.0, 63.0),
			"bandNew" : RgbToColor(215.0, 37.0, 69.0),
		},
		"textures" : {
			
		}
	},
	537 : {
		"name": "Master's Robe",
		"description" : "a robe made for master wizards and magicians",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"defense" : 6,
			"attack" : 10
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,5)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(108.0, 0.0, 142.0),
			"bodyLightNew" : RgbToColor(157.0, 0.0, 162.0),
			"bandNew" : RgbToColor(190.0, 0.0, 177.0),
		},
		"textures" : {
			
		}
	},
	538 : {
		"name": "Sandora Robe",
		"description" : "A sandy robe torn off an ancient mummy",
		"type" : "Robe",
		"slot" : "armor",
		"tier" : "UT",
		
		"stats" : {
			"defense" : 7,
			"dexterity" : 10,
			"attack" : 1
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,5)],
		"colors" : {
		},
		"textures" : {
			"bodyTexture" : "desert_headdress",
		}
	},
	566 : {
		"name": "Worn Tunic",
		"description" : "An old tunic not worth its weight in fabric",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "0",
		
		"stats" : {
			"speed" : 2,
			"defense" : 1 
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(105, 51.0, 10.0),
			"bodyLightNew" : RgbToColor(123.0, 72.0, 17.0),
			"bandNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	567 : {
		"name": "Leather Tunic",
		"description" : "A simple leather tunic",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "1",
		
		"stats" : {
			"speed" : 3,
			"defense" : 3 
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(161, 87.0, 8.0),
			"bodyLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"bandNew" : RgbToColor(207.0, 189.0, 56.0),
		},
		"textures" : {
			
		}
	},
	568 : {
		"name": "Magic Tunic",
		"description" : "A tunic imbued with magical properties",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "2",
		
		"stats" : {
			"speed" : 4,
			"defense" : 5
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(23.0, 163.0, 163.0),
			"bodyLightNew" : RgbToColor(25.0, 182.0, 182.0),
			"bandNew" : RgbToColor(225.0, 222.0, 213.0),
		},
		"textures" : {
			
		}
	},
	569 : {
		"name": "Foxhide Tunic",
		"description" : "A powerful tunic made from the hide of a swift fox",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "3",
		
		"stats" : {
			"speed" : 5,
			"defense" : 7
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(163.0, 49.0, 29.0),
			"bodyLightNew" : RgbToColor(189.0, 57.0, 34.0),
			"bandNew" : RgbToColor(213.0, 213.0, 148.0),
		},
		"textures" : {
			
		}
	},
	570 : {
		"name": "Snakeskin Tunic",
		"description" : "A tunic crafted from a basalisk, made for a master archer",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "4",
		
		"stats" : {
			"speed" : 6,
			"defense" : 10
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(24.0, 140.0, 89.0),
			"bodyLightNew" : RgbToColor(37.0, 158.0, 105.0),
			"bandNew" : RgbToColor(231.0, 211.0, 61.0),
		},
		"textures" : {
			
		}
	},
	571 : {
		"name": "Golden Tunic",
		"description" : "A tunic carefully crafted to make the wearer extra light on their feet",
		"type" : "Hide",
		"slot" : "armor",
		"tier" : "UT",
		
		"stats" : {
			"speed" : 20,
			"dexterity" : 5,
			"defense" : 5,
		},
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,6)],
		"colors" : {
			"bodyMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"bodyLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"bandNew" : RgbToColor(78.0, 155.0, 36.0),
		},
		"textures" : {
			
		}
	},
	400 : {
		"name": "Iron Helmet",
		"description" : "A basic helmet that has seen many battles.",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 2, "range" : 8},
		},
		"stats" : {
			"defense" : 5,
			"vitality" : 5,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,8)],
		"colors" : {
			"helmetMediumNew" : RgbToColor(157.0, 153.0, 135.0),
			"helmetLightNew" : RgbToColor(174.0, 172.0, 156.0),
			"helmetDarkNew" : RgbToColor(143.0, 138.0, 118.0),
		},
		"textures" : {
			
		}
	},
	401 : {
		"name": "Gold Helmet",
		"description" : "A sturdy gold helmet",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 2.5, "range" : 8},
		},
		"stats" : {
			"defense" : 7,
			"vitality" : 7,
		},
		"tier" : "1",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			
		}
	},
	402 : {
		"name": "Platinum Helmet",
		"description" : "A durable helmet made out of a premium platinum alloy",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 3, "range" : 8},
		},
		"stats" : {
			"defense" : 9,
			"vitality" : 9,
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,8)],
		
		"colors" : {
			"helmetLightNew" : Color("c6b078"),
			"helmetMediumNew" : Color("d8d8d8"),
			"helmetDarkNew" : Color("b5b5b5"),
		},
		"textures" : {
			
		}
	},
	403 : {
		"name": "Mithril Helmet",
		"description" : "A perfectly crafted helmet made from a magic ore",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 4, "range" : 8},
		},
		"stats" : {
			"defense" : 10,
			"vitality" : 10,
		},
		"tier" : "3",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(25.0, 182.0, 182.0),
			"helmetDarkNew" : RgbToColor(23.0, 163.0, 163.0),
		},
		"textures" : {
			
		}
	},
	404 : {
		"name": "Rexium Helmet",
		"description" : "You wont find a helmet stronger than this",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 5.5, "range" : 8},
		},
		"stats" : {
			"defense" : 15,
			"vitality" : 15,
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(153.0, 3.0, 19.0),
			"helmetDarkNew" : RgbToColor(125.0, 26.0, 22.0),
		},
		"textures" : {
			
		}
	},
	405 : {
		"name": "Everwinter Diadem",
		"description" : "A grand helm, cold to the touch",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"invincible" : { "duration" : 2, "range" : 0},
			"healing" : { "duration" : 2, "range" : 6},
			"armored" : { "duration" : 4, "range" : 6},
		},
		"stats" : {
			"health" : 150,
			"defense" : 10,
		},
		"tier" : "UT",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(160.0, 178.0, 186.0),
			"helmetMediumNew" : RgbToColor(80.0, 81.0, 75.0),
			"helmetDarkNew" : RgbToColor(60.0, 60.0, 54.0),
		},
		"textures" : {
			"helmetTexture" : "everwinter_diadem",
		}
	},
	406 : {
		"name": "Pumpkin Helmet",
		"description" : "You wont find a helmet tastier than this",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"armored" : { "duration" : 5.5, "range" : 8},
		},
		"stats" : {
			"defense" : 15,
			"vitality" : 15,
		},
		"tier" : "5",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(5,14)],
		"colors" : {
			"helmetLightNew" : RgbToColor(255.0, 193.0, 92.0),
			"helmetMediumNew" : RgbToColor(228.0, 91.0, 9.0),
			"helmetDarkNew" : RgbToColor(206.0, 81.0, 5.0),
		},
		"textures" : {
			
		}
	},
	407 : {
		"name": "Bonewick Helmet",
		"description" : "A scaley helm made from the hide of Argolath",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 6,
		"buffs" : {
			"healing" : { "duration" : 2, "range" : 1},
			"armored" : { "duration" : 2, "range" : 1},
		},
		"stats" : {
			"dexterity" : 10,
			"attack" : 10,
			"defense" : 10,
			"health" : 100,
		},
		"tier" : "UT",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,8)],
		"colors" : {
			"helmetLightNew" : RgbToColor(160.0, 178.0, 186.0),
			"helmetMediumNew" : RgbToColor(80.0, 81.0, 75.0),
			"helmetDarkNew" : RgbToColor(60.0, 60.0, 54.0),
		},
		"textures" : {
			"helmetTexture" : "bonewick_helmet",
		}
	},
	433 : {
		"name": "Worn Hat",
		"description" : "A miserable hat hardly fit for casting spells",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 1, "range" : 8},
		},
		"stats" : {
			"attack" : 3,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(92.0, 97.0, 158.0),
			"helmetMediumNew" : RgbToColor(79.0, 77.0, 144.0),
			"helmetDarkNew" : RgbToColor(62.0, 60.0, 124.0),
		},
		"textures" : {
			
		}
	},
	434 : {
		"name": "Wizard's Hat",
		"description" : "A slightly magical hat fit for casting spells",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 1.5, "range" : 8},
		},
		"stats" : {
			"attack" : 5,
			"defense" : 1
		},
		"tier" : "1",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(58.0, 66.0, 168.0),
			"helmetMediumNew" : RgbToColor(54.0, 51.0, 148.0),
			"helmetDarkNew" : RgbToColor(54.0, 51.0, 148.0),
		},
		"textures" : {
			
		}
	},
	435 : {
		"name": "Eagle-feather Hat",
		"description" : "A hat made for a strong druid",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 2, "range" : 8},
		},
		"stats" : {
			"attack" : 7,
			"defense" : 2
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,9)],
		
		"colors" : {
			"helmetLightNew" : RgbToColor(184.0, 135, 8.0),
			"helmetMediumNew" : RgbToColor(150.0, 109.0, 0.0),
			"helmetDarkNew" : RgbToColor(134.0, 97.0, 0.0),
		},
		"textures" : {
			
		}
	},
	436 : {
		"name": "Solar Hat",
		"description" : "A wizard hat made from the beams of the sun",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 2.5, "range" : 8},
		},
		"stats" : {
			"attack" : 9,
			"defense" : 2
		},
		"tier" : "3",
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(255.0, 234.0, 69.0),
			"helmetMediumNew" : RgbToColor(232.0, 211.0, 63.0),
			"helmetDarkNew" : RgbToColor(207.0, 189.0, 56.0),
		},
		"textures" : {
			
		}
	},
	437 : {
		"name": "Celestial Hat",
		"description" : "A hat only the greatest wizards are worthy to wear",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 3, "range" : 8},
		},
		"stats" : {
			"attack" : 12,
			"defense" : 3
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(190.0, 0.0, 177.0),
			"helmetMediumNew" : RgbToColor(157.0, 0.0, 162.0),
			"helmetDarkNew" : RgbToColor(108.0, 0.0, 142.0),
		},
		"textures" : {
			
		}
	},
	438 : {
		"name": "Beastly Hat",
		"description" : "A hat crafted by the imp tribes of a time forgotten",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 3,
		"buffs" : {
			"healing" : { "duration" : 2, "range" : 5},
			"damaging" : { "duration" : 2, "range" : 5},
		},
		"stats" : {
			"attack" : 10,
			"dexterity" : 10,
		},
		"tier" : "UT",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(96.0, 63.0, 131.0),
			"helmetMediumNew" : RgbToColor(132.0, 47.0, 33.0),
			"helmetDarkNew" : RgbToColor(98.0, 29.0, 17.0),
		},
		"textures" : {
			"helmetTexture" : "beastly_hat",
		}
	},
	439 : {
		"name": "Mask of Babel",
		"description" : "A mask worn by the greatest druid to have ever lived",
		"type" : "Hat",
		"slot" : "helmet",
		
		"cooldown" : 4,
		"buffs" : {
			"healing" : { "duration" : 4, "range" : 0},
		},
		"stats" : {
			"health" : 200,
		},
		"tier" : "UT",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(7,9)],
		"colors" : {
			"helmetLightNew" : RgbToColor(0.0, 0.0, 0.0),
			"helmetMediumNew" : RgbToColor(0.0, 0.0, 0.0),
			"helmetDarkNew" : RgbToColor(0.0, 0.0, 0.0),
		},
		"textures" : {
			"helmetTexture" : "mask_of_babel",
		}
	},
	466 : {
		"name": "Worn Cap",
		"description" : "A second hand cap used by beginner archers",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 2, "range" : 8},
		},
		"stats" : {
			"dexterity" : 3,
		},
		"tier" : "0",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(0,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(123.0, 72.0, 17.0),    #note, these colours do not match the sprite 1 to 1 and should be changed
			"helmetMediumNew" : RgbToColor(105, 51.0, 10.0),
			"helmetDarkNew" : RgbToColor(83.0, 39.0, 6.0),
		},
		"textures" : {
			
		}
	},
	467 : {
		"name": "Leather Cap",
		"description" : "A fine cap made from leather",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 2.5, "range" : 8},
		},
		"stats" : {
			"dexterity" : 4,
			"defense" : 1
		},
		"tier" : "1",
		"path" : ["items/items_8x8.png", 26, 26, Vector2(1,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(184.0, 99.0, 8.0),
			"helmetMediumNew" : RgbToColor(161, 87.0, 8.0),
			"helmetDarkNew" : RgbToColor(143.0, 75.0, 2.0),
		},
		"textures" : {
			
		}
	},
	468 : {
		"name": "Eagle-feather Cap",
		"description" : "An excellent cap made from the feathers of an eagle",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 3, "range" : 8},
		},
		"stats" : {
			"dexterity" : 6,
			"defense" : 2
		},
		"tier" : "2",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(2,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(184.0, 135, 8.0),
			"helmetMediumNew" : RgbToColor(150.0, 109.0, 0.0),
			"helmetDarkNew" : RgbToColor(134.0, 97.0, 0.0),
		},
		"textures" : {
			
		}
	},
	469 : {
		"name": "Foxskin Cap",
		"description" : "An elite cap made from the hide of a swift fox",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 3.5, "range" : 8},
		},
		"stats" : {
			"dexterity" : 7,
			"defense" : 3
		},
		"tier" : "3",
		"path" : ["items/items_8x8.png", 26, 26, Vector2(3,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(215.0, 67.0, 39.0),
			"helmetMediumNew" : RgbToColor(189.0, 57.0, 34.0),
			"helmetDarkNew" : RgbToColor(163.0, 49.0, 29.0),
		},
		"textures" : {
			
		}
	},
	470 : {
		"name": "Master's Cap",
		"description" : "A one of a kind cap passed down from master archers",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 7,
		"buffs" : {
			"berserk" : { "duration" : 4, "range" : 8},
		},
		"stats" : {
			"dexterity" : 9,
			"defense" : 4
		},
		"tier" : "4",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(4,10)],
		"colors" : {
			"helmetLightNew" : RgbToColor(23.0, 191.0, 16.0),
			"helmetMediumNew" : RgbToColor(17.0, 160.0, 12.0),
			"helmetDarkNew" : RgbToColor(9.0, 138.0, 5.0),
		},
		"textures" : {
			
		}
	},
	471 : {
		"name": "Desert Headdress",
		"description" : "An expertly crafted headdress, once worn by a great king",
		"type" : "Cap",
		"slot" : "helmet",
		
		"cooldown" : 10,
		"buffs" : {
			"berserk" : { "duration" : 4, "range" : 5},
			"damaging" : { "duration" : 2, "range" : 5},
		},
		"stats" : {
			"attack" : 8,
			"speed" : 6
		},
		"tier" : "UT",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,10)],
		"colors" : {
		},
		"textures" : {
			"helmetTexture" : "desert_headdress"
		}
	},
	499 : {
		"name": "Holy Crown",
		"description" : "No tree, it is said, can grow to heaven unless its roots reach down to hell",
		"type" : "Helmet",
		"slot" : "helmet",
		
		"cooldown" : 10,
		"buffs" : {
			"healing" : { "duration" : 3, "range" : 6},
			"berserk" : { "duration" : 3, "range" : 6},
			"armored" : { "duration" : 3, "range" : 6},
		},
		"stats" : {
			"dexterity" : 5,
			"vitality" : 5,
			"defense" : 5,
		},
		"tier" : "UT",
		
		"path" : ["items/items_8x8.png", 26, 26, Vector2(6,7)],
		"colors" : {
			"helmetLightNew" : RgbToColor(231.0, 211.0, 61.0),
			"helmetMediumNew" : RgbToColor(207.0, 189.0, 56.0),
			"helmetDarkNew" : RgbToColor(190.0, 168.0, 48.0),
		},
		"textures" : {
			"helmetTexture" : "holy_crown",
		}
	},
}

var buildings = {
	"storage" : {
		"name" : "Storage Chest",
		"type" : "object",
		"catagory" : "storage",
		"loot_slots" : 8,
		"description" : "For storing up to 8 items.",
		
		"craftable" : true,
		"materials" : [1, 1, 2],
		"max" : 20,
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(50,40)],
	},
	"grass" : {
		"name" : "Grass Tile",
		"type" : "tile",
		"description" : "Don't forget to water.",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["tiles/tileset.png", 26, 26, Vector2(0,60)],
		"tile" : 2,
	},
	"stone" : {
		"name" : "Stone Tile",
		"type" : "tile",
		"description" : "Hard as rock.",
		
		"craftable" : true,
		"materials" : [2],
		"max" : 200,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(70,60)],
		"tile" : 3,
	},
	"stone_wall" : {
		"name" : "Stone Wall",
		"type" : "tile",
		"wall" : true,
		"description" : "Fortress strength in every block.",
		
		"craftable" : true,
		"materials" : [2,2],
		"max" : 100,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(70,70)],
		"tile" : 4,
	},
	"wooden_planks" : {
		"name" : "Wooden Planks",
		"type" : "tile",
		"description" : "Straight from the docks.",
		
		"craftable" : true,
		"materials" : [1],
		"max" : 200,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(130,60)],
		"tile" : 5,
	},
	"wooden_wall" : {
		"name" : "Wooden Wall",
		"type" : "tile",
		"wall" : true,
		"description" : "Carved with care, built to last.",
		
		"craftable" : true,
		"materials" : [1,1],
		"max" : 100,
		"path" : ["tiles/tileset.png", 26, 26, Vector2(130,70)],
		"tile" : 6,
	},
	"wooden_bench" : {
		"name" : "Wooden Bench",
		"type" : "object",
		"catagory" : "statue",
		"description" : "A place to sit",
		
		"craftable" : true,
		"max" : 10,
		"materials" : [1],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(0,100)],
	},
	"wooden_chair" : {
		"name" : "Wooden Chair",
		"type" : "object",
		"catagory" : "statue",
		"description" : "A place to sit",
		
		"craftable" : true,
		"max" : 10,
		"materials" : [1],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(10,100)],
	},
	"item_stand" : {
		"name" : "Item Stand",
		"type" : "object",
		"catagory" : "storage",
		"loot_slots" : 1,
		"description" : "A place to display items.",
		
		"craftable" : true,
		"materials" : [0,1,1,1],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(10,110)],
	},
	"item_pillar" : {
		"name" : "Item Pillar",
		"type" : "object",
		"catagory" : "storage",
		"loot_slots" : 1,
		"description" : "A place to display rare items.",
		
		"craftable" : true,
		"materials" : [0,2,2,2],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(0,110)],
	},
	"item_monument" : {
		"name" : "Item Monument",
		"type" : "object",
		"catagory" : "storage",
		"loot_slots" : 1,
		"description" : "Wheres my crown, thats my bling",
		
		"craftable" : true,
		"materials" : [0,0,-1,-1,-2,-2],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(20,110)],
	},
	"apprentice_statue" : {
		"name" : "Apprentice Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a health boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(60,40)],
	},
	"noble_statue" : {
		"name" : "Noble Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a defense boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(70,40)],
		"achievement" : "Noble Statue",
	},
	"nomad_statue" : {
		"name" : "Nomad Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a fire rate boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(80,40)],
		"achievement" : "Unlock Nomad",
	},
	"scholar_statue" : {
		"name" : "Scholar Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a health regen boost (2m).",
		
		"craftable" : false,
		"materials" : [],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(90,40)],
		"achievement" : "Unlock Scholar",
	},
	"dragon_statue" : {
		"name" : "Dragon Statue",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a ??? boost (2m).",
		
		"craftable" : true,
		"materials" : [104,504,404,3],
		"path" : ["objects/objects_16x16.png", 15, 15, Vector2(18,18)],
	},
	"elemental_orb" : {
		"name" : "Elemental Orb",
		"type" : "object",
		"catagory" : "statue",
		"description" : "Gives nearby players a ??? boost (2m).",
		
		"craftable" : true,
		"materials" : [135,138,141,3],
		"path" : ["objects/objects_8x8.png", 26, 26, Vector2(10,120)],
	},
}

var projectiles = {
	"TunaSlash" : {
		"rect" : Rect2(70,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	
	"PlasmaFlipped" : {
		"rect" : Rect2(180,20,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Plasma1" : {
		"rect" : Rect2(180,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Plasma2" : {
		"rect" : Rect2(190,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"SmallPlasmaBall" : {
		"rect" : Rect2(200,10,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8
	},
	"PlasmaBall" : {
		"rect" : Rect2(200,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"PlasmaSpinner" : {
		"rect" : Rect2(210,10,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"GiantPlasmaSpinner" : {
		"rect" : Rect2(210,10,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.4
	},
	
	"Slash" : {
		"rect" : Rect2(0,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"Wave" : {
		"rect" : Rect2(10,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Ball" : {
		"rect" : Rect2(20,0,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"GiantBall" : {
		"rect" : Rect2(20,0,10,10),
		"rotation" : 90,
		"spin" : false,
		"scale" : 1.5
	},
	"GiantStack" : {
		"rect" : Rect2(30,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5
	},
	"Stack" : {
		"rect" : Rect2(30,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"CannonBall" : {
		"rect" : Rect2(40,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GoldDart" : {
		"rect" : Rect2(150,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"VigilBlast" : {
		"rect" : Rect2(160,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.2,
	},
	"VigilBlastSmall" : {
		"rect" : Rect2(170,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"SandBlast" : {
		"rect" : Rect2(160,10,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.1,
	},
	"SandBlastSmall" : {
		"rect" : Rect2(170,10,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.3,
	},
	"RockBlast" : {
		"rect" : Rect2(160,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"RockBlastSmall" : {
		"rect" : Rect2(170,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"NeonStar" : {
		"rect" : Rect2(180,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"NeonArrow" : {
		"rect" : Rect2(190,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"Blast" : {
		"rect" : Rect2(90,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantBlast" : {
		"rect" : Rect2(90,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.6,
	},
	"SmallBlast" : {
		"rect" : Rect2(100,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GreenBlast" : {
		"rect" : Rect2(110,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BrownBlast" : {
		"rect" : Rect2(120,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BlueBlast" : {
		"rect" : Rect2(130,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"RedBlast" : {
		"rect" : Rect2(140,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"IronSlash" : {
		"rect" : Rect2(0,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"GoldSlash" : {
		"rect" : Rect2(10,10,10,10),
		"rotation" : 90,
		"spin" : false,
	},
	"PlatinumSlash" : {
		"rect" : Rect2(20,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"MithrilSlash" : {
		"rect" : Rect2(30,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"RexiumSlash" : {
		"rect" : Rect2(60,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"RedRexiumSlash" : {
		"rect" : Rect2(40,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"BattleaxeSlash" : {
		"rect" : Rect2(50,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"SteelArrow" : {
		"rect" : Rect2(0,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GoldenArrow" : {
		"rect" : Rect2(10,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"MagicArrow" : {
		"rect" : Rect2(20,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"BloodArrow" : {
		"rect" : Rect2(30,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.85,
	},
	"ShadowArrow" : {
		"rect" : Rect2(40,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.9,
	},
	"GiantShadowArrow" : {
		"rect" : Rect2(40,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.1,
	},
	"ArchaicArrow" : {
		"rect" : Rect2(50,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"Nature1" : {
		"rect" : Rect2(0,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Water1" : {
		"rect" : Rect2(10,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire1" : {
		"rect" : Rect2(20,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Nature2" : {
		"rect" : Rect2(30,30,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.1,
	},
	"Water2" : {
		"rect" : Rect2(40,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire2" : {
		"rect" : Rect2(50,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Nature3" : {
		"rect" : Rect2(60,30,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.2,
	},
	"Water3" : {
		"rect" : Rect2(70,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Fire3" : {
		"rect" : Rect2(80,30,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantVoid" : {
		"rect" : Rect2(90,30,10,10),
		"rotation" : 90,
		"spin" : true,
		"scale" : 1.6,
	},
	"Void1" : {
		"rect" : Rect2(90,30,10,10),
		"rotation" : 90,
		"spin" : true,
	},
	"FlameBurst" : {
		"rect" : Rect2(200,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"FlameArrow" : {
		"rect" : Rect2(210,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 0.8,
	},
	"GiantFlameArrow" : {
		"rect" : Rect2(210,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"FlameBlast" : {
		"rect" : Rect2(220,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"GiantFlameBlast" : {
		"rect" : Rect2(220,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"IceSlash" : {
		"rect" : Rect2(230,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantIceSlash" : {
		"rect" : Rect2(230,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.5,
	},
	"IceSpinner" : {
		"rect" : Rect2(230,10,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"GiantIceSpinner" : {
		"rect" : Rect2(230,10,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.5,
	},
	"AbyssSpinner" : {
		"rect" : Rect2(240,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"GiantAbyssSpinner" : {
		"rect" : Rect2(240,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.6,
	},
	"RoyalSlash" : {
		"rect" : Rect2(250,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"GiantRoyalSlash" : {
		"rect" : Rect2(250,0,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"AbyssBlast" : {
		"rect" : Rect2(240,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantAbyssBlast" : {
		"rect" : Rect2(240,10,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"IceBlast" : {
		"rect" : Rect2(250,10,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"GiantIceBlast" : {
		"rect" : Rect2(250,10,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"GiantDemonicBlast" : {
		"rect" : Rect2(230,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1.4,
	},
	"DemonicBlast" : {
		"rect" : Rect2(230,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"SmallDemonicBlast" : {
		"rect" : Rect2(230,30,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"DemonicWave" : {
		"rect" : Rect2(240,20,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"BloodSpinner" : {
		"rect" : Rect2(250,20,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"BloodSlash" : {
		"rect" : Rect2(250,40,10,10),
		"rotation" : 45,
		"spin" : false,
		"scale" : 1,
	},
	"BloodShuriken" : {
		"rect" : Rect2(250,30,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1,
	},
	"Ring" : {
		"rect" : Rect2(50,0,10,10),
		"rotation" : 90,
		"spin" : false,
		"scale" : 1.3,
	},
	"Dart" : {
		"rect" : Rect2(60,0,10,10),
		"rotation" : 45,
		"spin" : false,
	},
	"Spinner" : {
		"rect" : Rect2(70,0,10,10),
		"rotation" : 45,
		"spin" : true,
	},
	"GiantSpinner" : {
		"rect" : Rect2(70,0,10,10),
		"rotation" : 45,
		"spin" : true,
		"scale" : 1.4,
	},
	"Star" : {
		"rect" : Rect2(80,0,10,10),
		"rotation" : 45,
		"spin" : true,
	},
}

var achievement_catagories = {
	"Classes" : { 
		"achievements" : ["Job Hopper", "Westerly Winds", "Starlight, Starbright", "Brave Story", "True Warrior"], 
		"icon" : Vector2(0,0)
	},
	"Combat" : {
		"achievements" : ["Back From The Dead", "Sharpest Shooter", "Druidic Slayer", "On The Rocks", "History Of Beasts", "Fear To Fortitude", "Dragon Slayer"], 
		"icon" : Vector2(10,0)
	},
	"Misc" : { 
		"achievements" : ["Mr. Worldwide I", "Mr. Worldwide II","6 Feet Under I","6 Feet Under II","6 Feet Under III"], 
		"icon" : Vector2(20,0)
	},
}

var achievements = {
	"6 Feet Under I" : {
		"which" : "deaths",
		"amount" : 5,
		"icon" : Vector2(0,30),
		"description" : "Die 5 times.",
		"gold" : 200,
	},
	"6 Feet Under II" : {
		"which" : "deaths",
		"amount" : 25,
		"icon" : Vector2(0,30),
		"description" : "Die 25 times.",
		"gold" : 400,
	},
	"6 Feet Under III" : {
		"which" : "deaths",
		"amount" : 125,
		"icon" : Vector2(0,30),
		"description" : "Die 125 times.",
		"gold" : 800,
	},
	"Mr. Worldwide I" : {
		"which" : "tiles_covered",
		"amount" : 100000,
		"icon" : Vector2(10,30),
		"description" : "Travel 100000 tiles.",
		"gold" : 200,
	},
	"Mr. Worldwide II" : {
		"which" : "tiles_covered",
		"amount" : 1000000,
		"icon" : Vector2(10,30),
		"description" : "Travel 1000000 tiles.",
		"gold" : 400,
	},
	"Back From The Dead" : {
		"which" : "enemies_killed",
		"amount" : 100,
		"enemies" : ["skeletal_warrior", "skeletal_archer"],
		"icon" : Vector2(20,20),
		"description" : "Kill 100 skeletons.",
		"gold" : 200,
	},
	"Sharpest Shooter" : {
		"which" : "projectiles_landed",
		"amount" : 1000000,
		"icon" : Vector2(60,20),
		"description" : "Land 1000000 projectiles.",
		"gold" : 300,
	},
	"Druidic Slayer" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["ice_druid", "nature_druid", "fire_druid", "shadow_druid"],
		"icon" : Vector2(10,20),
		"description" : "Kill 1000 druids.",
		"gold" : 300,
	},
	"On The Rocks" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["rock_sprite", "rock_scorpion", "lil_rock_golem", "rokk_the_rough", "rock_sprite_rotating"],
		"icon" : Vector2(40,20),
		"description" : "Kill 1000 rock enemies.",
		"gold" : 400,
	},
	"History Of Beasts" : {
		"which" : "enemies_killed",
		"amount" : 1000,
		"enemies" : ["cacodemon", "basalisk", "phoenix", "archmage"],
		"icon" : Vector2(0,20),
		"description" : "Kill 1000 gods.",
		"gold" : 400,
	},
	"Fear To Fortitude" : {
		"which" : "damage_taken",
		"amount" : 1000000,
		"icon" : Vector2(30,20),
		"description" : "Take 1000000 points of damage.",
		"gold" : 600,
	},
	"Dragon Slayer" : {
		"which" : "enemies_killed",
		"amount" : 50,
		"enemies" : ["salazar,_rex_of_the_abyss"],
		"icon" : Vector2(50, 20),
		"description" : "Kill salazar in the abyss 50 times.",
		"gold" : 800,
	},
	"Job Hopper" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Noble","Scholar","Nomad"],
		"icon" : Vector2(0,0),
		"description" : "Unlock the 3 base classes.",
		"gold" : 400,
	},
	"Westerly Winds" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Sentinel","Ranger","Scout"],
		"icon" : Vector2(10,10),
		"description" : "Unlock the 3 Nomad secondary classes.",
		"gold" : 800,
	},
	"Starlight, Starbright" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Druid","Magician","Warlock"],
		"icon" : Vector2(0,10),
		"description" : "Unlock the 3 Scholar secondary classes.",
		"gold" : 800,
	},
	"Brave Story" : {
		"which" : "classes_unlocked",
		"amount" : 3,
		"classes" : ["Knight","Paladin","Marauder"],
		"icon" : Vector2(20,10),
		"description" : "Unlock the 3 Noble secondary classes.",
		"gold" : 800,
	},
	"True Warrior" : {
		"which" : "classes_unlocked",
		"amount" : 9,
		"classes" : ["Knight","Paladin","Marauder"]+["Druid","Magician","Warlock"]+["Sentinel","Ranger","Scout"],
		"icon" : Vector2(30,10),
		"description" : "Unlock all 9 secondary classes.",
		"gold" : 1600,
	},
	"Unlock Nomad" : {
		"which" : "bow_projectiles",
		"amount" : 9000,
		"icon" : Vector2(0,10),
		"description" : "Become one with the arrow.",
		"gold" : 0,
	},
	"Unlock Noble" : {
		"which" : "sword_projectiles",
		"amount" : 3000,
		"icon" : Vector2(0,10),
		"description" : "Become one with the blade.",
		"gold" : 0,
	},
	"Unlock Scholar" : {
		"which" : "staff_projectiles",
		"amount" : 6000,
		"icon" : Vector2(0,10),
		"description" : "Become one with the magic.",
		"gold" : 0,
	},
	"Unlock Knight" : {
		"which" : "damage_taken",
		"amount" : 200000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Paladin" : {
		"which" : "ability_used",
		"amount" : 1000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Marauder" : {
		"which" : "enemies_killed",
		"amount" : 3,
		"enemies" : ["salazar,_rex_of_the_abyss"],
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Ranger" : {
		"which" : "enemies_killed",
		"amount" : 10,
		"enemies" : ["atlas","og_the_treacherous","vigil_guardian"],
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Sentinel" : {
		"which" : "damage_taken",
		"amount" : 200000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Scout" : {
		"which" : "tiles_covered",
		"amount" : 50000,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Magician" : {
		"which" : "ability_used",
		"amount" : 1200,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Druid" : {
		"which" : "enemies_killed",
		"amount" : 200,
		"enemies" : ["phoenix"],
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
	"Unlock Warlock" : {
		"which" : "enemies_killed",
		"amount" : 2500,
		"icon" : Vector2(0,10),
		"description" : "Take some serious damage.",
		"gold" : 0,
	},
}
#The enemy kills we need to keep track of on the player
var enemies_tracked = []

var characters = {
	"Apprentice" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Nomad" :  "Nomad",
			"Unlock Noble" : "Noble",
			"Unlock Scholar" : "Scholar",
		},
		"rect" : Rect2(0,0,80,40),
		"icon" : Vector2(0,210),
		"color" : Color(196.0/255, 184.0/255, 146.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(113.0, 55.0, 16.0),
					"helmetMediumNew" : RgbToColor(126.0, 67.0, 27.0),
					"helmetLightNew" : RgbToColor(144.0, 81.0, 38.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 0,
			"defense" : 0,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 0
		},
		"multipliers" : {
		},
		"description" : "The apprentice is a quick learner who can wield any weapon.",
		"ascension_stones" : 5,
	},
	"Noble" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Knight" :  "Knight",
			"Unlock Paladin" : "Paladin",
			"Unlock Marauder" : "Marauder",
		},
		"rect" : Rect2(0,40,80,40),
		"icon" : Vector2(20,210),
		"color" : Color(252.0/255, 139.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 200,
			"attack" : 5,
			"defense" : 20,
			"speed" : 0,
			"dexterity" : 5,
			"vitality" : 20
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.2, "stats" : 1.2},
			"Armor" : {"stats" : 1.2},
			"Helmet" : {"stats" : 1.2},
		},
		"description" : "The Noble's strength and bravery dominate the battlefield.",
		"teaser" : "Discover by becoming one with the blade.",
		"ascension_stones" : 50,
	},
	"Nomad" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Ranger" :  "Ranger",
			"Unlock Sentinel" : "Sentinel",
			"Unlock Scout" : "Scout",
		},
		"rect" : Rect2(80,80,80,40),
		"icon" : Vector2(10,210),
		"color" : Color(78.0/255, 166.0/255, 63.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(113.0, 55.0, 16.0),
					"helmetMediumNew" : RgbToColor(126.0, 67.0, 27.0),
					"helmetLightNew" : RgbToColor(144.0, 81.0, 38.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 5,
			"defense" : 0,
			"speed" : 20,
			"dexterity" : 20,
			"vitality" : 0
		},
		"multipliers" : {
			"Bow" : {"rof" : 1.2, "stats" : 1.2},
			"Hide" : {"stats" : 1.2},
			"Cap" : {"stats" : 1.2},
		},
		"description" : "Swift and precise, the Nomad's arrows strike fear into distant foes.",
		"teaser" : "Discover by becoming one with the arrow.",
		"ascension_stones" : 50,
	},
	"Scholar" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
			"Unlock Magician" :  "Magician",
			"Unlock Druid" : "Druid",
			"Unlock Warlock" : "Warlock",
		},
		"rect" : Rect2(160,120,80,40),
		"icon" : Vector2(30,210),
		"color" : Color(62.0/255, 118.0/255, 255.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(62.0, 60.0, 124.0),
					"helmetMediumNew" : RgbToColor(77.0, 79.0, 144.0),
					"helmetLightNew" : RgbToColor(92.0, 97.0, 158.0),
				},
				"textures" : {
				},
			}
		},
		"bonus_stats" : {
			"health" : 50,
			"attack" : 30,
			"defense" :0,
			"speed" : 5,
			"dexterity" : 5,
			"vitality" : 10
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.2, "stats" : 1.2},
			"Robe" : {"stats" : 1.2},
			"Hat" : {"stats" : 1.2},
		},
		"description" : "With powerful spells and vast intellect, the Scholar excels at long range.",
		"teaser" : "Discover by becoming one with magic.",
		"ascension_stones" : 50,
	},
	"Knight" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,160,80,40),
		"icon" : Vector2(110,210),
		"color" : Color(232.0/255, 105.0/255, 0.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 0,
			"defense" : 10,
			"speed" : -10,
			"dexterity" : 0,
			"vitality" : 10,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.4, "stats" : 1.4},
			"Armor" : {"stats" : 1.5},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Knight's high health and mighty armor make them an immovable force.",
		"teaser" : "Discover by enduring the trials of the battlefield.",
		"ascension_stones" : 75,
	},
	"Paladin" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,200,80,40),
		"icon" : Vector2(100,210),
		"color" : Color(252.0/255, 218.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 50,
			"attack" : 0,
			"defense" : 0,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 20,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.4, "stats" : 1.4},
			"Robe" : {"stats" : 1.4},
			"Armor" : {"stats" : 1.2},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Paladin's high regen and health make them the ultimate tank.",
		"teaser" : "Discover by using your head.",
		"ascension_stones" : 75,
	},
	"Marauder" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,240,80,40),
		"icon" : Vector2(120,210),
		"color" : Color(252.0/255, 72.0/255, 14.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(85.0, 76.0, 73.0),
					"helmetLightNew" : RgbToColor(157.0, 153.0, 135.0),
					"helmetMediumNew" : RgbToColor(107.0, 95.0, 91.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 10,
			"defense" : 0,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 0,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.5, "stats" : 1.4},
			"Hide" : {"stats" : 1.4},
			"Armor" : {"stats" : 1.2},
			"Helmet" : {"stats" : 1.4},
		},
		"description" : "The Marauder's sharp blade and swift blows make them a unstoppable force.",
		"teaser" : "Discover by truly conquering the abyss.",
		"ascension_stones" : 75,
	},
	"Ranger" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,280,80,40),
		"icon" : Vector2(60,210),
		"color" : Color(164.0/255, 166.0/255, 63.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(113.0, 55.0, 16.0),
					"helmetMediumNew" : RgbToColor(126.0, 67.0, 27.0),
					"helmetLightNew" : RgbToColor(144.0, 81.0, 38.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 20,
			"defense" : 0,
			"speed" : 0,
			"dexterity" : 10,
			"vitality" : 0,
		},
		"multipliers" : {
			"Bow" : {"damage" : 1.2, "rof" : 1.4, "stats" : 1.4},
			"Hide" : {"stats" : 1.2},
			"Robe" : {"stats" : 1.4},
			"Cap" : {"stats" : 1.4},
		},
		"description" : "The Ranger's extreme power and precision make them a feared marksman.",
		"teaser" : "Discover by hunting the biggest prey in the island.",
		"ascension_stones" : 75,
	},
	"Sentinel" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,320,80,40),
		"icon" : Vector2(70,210),
		"color" : Color(38.0/255, 186.0/255, 169.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(113.0, 55.0, 16.0),
					"helmetMediumNew" : RgbToColor(126.0, 67.0, 27.0),
					"helmetLightNew" : RgbToColor(144.0, 81.0, 38.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 0,
			"defense" : 10,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 0,
		},
		"multipliers" : {
			"Bow" : {"rof" : 1.4, "stats" : 1.4},
			"Hide" : {"stats" : 1.2},
			"Armor" : {"stats" : 1.4},
			"Cap" : {"stats" : 1.4},
		},
		"description" : "The Sentinel's thick hide make them a robust marksman.",
		"teaser" : "Discover by enduring the trials of the battlefield.",
		"ascension_stones" : 75,
	},
	"Scout" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,360,80,40),
		"icon" : Vector2(80,210),
		"color" : Color(41.0/255, 134.0/255, 74.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(113.0, 55.0, 16.0),
					"helmetMediumNew" : RgbToColor(126.0, 67.0, 27.0),
					"helmetLightNew" : RgbToColor(144.0, 81.0, 38.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 50,
			"attack" : 0,
			"defense" : 0,
			"speed" : 20,
			"dexterity" : 0,
			"vitality" : 0,
		},
		"multipliers" : {
			"Bow" : {"rof" : 1.4, "stats" : 1.4},
			"Hide" : {"stats" : 1.4},
			"Cap" : {"stats" : 1.4},
		},
		"description" : "The Scout's swift nature makes them the fastest marksman.",
		"teaser" : "Discover by venturing far AND wide.",
		"ascension_stones" : 75,
	},
	"Magician" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,440,80,40),
		"icon" : Vector2(140,210),
		"color" : Color(62.0/255, 179.0/255, 221.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(62.0, 60.0, 124.0),
					"helmetMediumNew" : RgbToColor(77.0, 79.0, 144.0),
					"helmetLightNew" : RgbToColor(92.0, 97.0, 158.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 0,
			"defense" : 0,
			"speed" : 20,
			"dexterity" : 0,
			"vitality" : 10,
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.4, "stats" : 1.4},
			"Robe" : {"stats" : 1.2},
			"Hide" : {"stats" : 1.4},
			"Hat" : {"stats" : 1.4},
		},
		"description" : "The Magician's quick thinking make for a cunning opponent.",
		"teaser" : "Discover by pulling too many rabbits out of your hat.",
		"ascension_stones" : 75,
	},
	"Druid" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,400,80,40),
		"icon" : Vector2(150,210),
		"color" : Color("3e76dd"),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(62.0, 60.0, 124.0),
					"helmetMediumNew" : RgbToColor(77.0, 79.0, 144.0),
					"helmetLightNew" : RgbToColor(92.0, 97.0, 158.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 100,
			"attack" : 0,
			"defense" : 10,
			"speed" : 0,
			"dexterity" : 0,
			"vitality" : 0,
		},
		"multipliers" : {
			"Staff" : {"damage" : 1.4, "stats" : 1.4},
			"Robe" : {"stats" : 1.2},
			"Armor" : {"stats" : 1.4},
			"Hat" : {"stats" : 1.4},
		},
		"description" : "The Druid's extreme durability and regeneration can outlast anyone.",
		"teaser" : "Discover by putting out some serious fire.",
		"ascension_stones" : 75,
	},
	"Warlock" : {
		"path" : ["characters/characters_8x8.png", 4, 4, Vector2(0,0)],
		"quests" : {
		},
		"rect" : Rect2(0,480,80,40),
		"icon" : Vector2(160,210),
		"color" : Color(131.0/255, 62.0/255, 221.0/255),
		"example_colors" : {
			"params" : {
				"colors" : {
					"helmetDarkNew" : RgbToColor(62.0, 60.0, 124.0),
					"helmetMediumNew" : RgbToColor(77.0, 79.0, 144.0),
					"helmetLightNew" : RgbToColor(92.0, 97.0, 158.0),
				},
				"textures" : {
					
				},
			}
		},
		"bonus_stats" : {
			"health" : 0,
			"attack" : 20,
			"defense" : -10,
			"speed" : 10,
			"dexterity" : 10,
			"vitality" : 0,
		},
		"multipliers" : {
			"Sword" : {"damage" : 1.4, "stats" : 1.4},
			"Staff" : {"damage" : 1.4, "rof" : 1.1, "stats" : 1.4},
			"Robe" : {"stats" : 1.4},
			"Hat" : {"stats" : 1.4},
		},
		"description" : "The Warlocks mastery of both sword and staff make them a feared mage.",
		"teaser" : "Discover by killing everything in sight.",
		"ascension_stones" : 75,
	},
}

func DegreesToVector(degrees):
	var radians = deg2rad(degrees)
	var vector = Vector2(cos(radians), sin(radians))
	return vector

func RgbToColor(r, g, b):
	r = r*1.0
	g = g*1.0
	b = b*1.0
	return Color(r/255, g/255, b/255)

func GetMultiplier(id, classname = GameHandler.character.class if GameHandler.character else "Apprentice"):
	var item = items[int(id)].duplicate(true)
	var multipliers = characters[classname].multipliers
	var result = {}
	
	for type in multipliers.keys():
		if item.type == type:
			for subject in multipliers[type].keys():
				result[subject] = multipliers[type][subject]
	
	return result

func GetItem(item, include_class_boost = false, _class = GameHandler.character.class if GameHandler.character else "Apprentice"):
	if items.has(int(item)) and include_class_boost:
		var _item = items[int(item)].duplicate(true)
		for type in characters[_class].multipliers.keys():
			var multipliers = characters[_class].multipliers[type]
			if _item.type == type:
				for subject in multipliers.keys():
					if subject == "damage":
						var index = -1
						for projectile in _item.projectiles:
							index += 1
							_item.projectiles[index][subject][0] = floor(projectile.damage[0]*multipliers[subject])
							_item.projectiles[index][subject][1] = floor(projectile.damage[1]*multipliers[subject])
					elif subject == "stats":
						for stat in _item[subject]:
							_item[subject][stat] = floor(_item[subject][stat]*multipliers[subject])
					else:
						_item[subject] = floor(_item[subject]*multipliers[subject])
		
		return _item
	elif items.has(int(item)):
		return items[int(item)]
	else:
		return null

func GetBuilding(type):
	if buildings.has(type):
		return buildings[type]
	else:
		return null

func GetProjectile(projectile):
	if projectiles.has(projectile):
		return projectiles[projectile]
	else:
		return null

func GetCharacter(character):
	if characters.has(character):
		return characters[character]
	else:
		return null

func GetEnemy(enemy):
	if enemies.has(enemy):
		return enemies[enemy]
	else:
		return null
		
func GetAchievement(achievement):
	if achievements.has(achievement):
		return achievements[achievement]
	else:
		return null

func CompileJSON():
	var result = {
		"Enemies" : enemies,
		"Dungeons" : dungeons,
		"Achievements" : achievements,
		"Projectiles" : projectiles,
		"ProjectileDatabase" : projectile_databank,
		"Classes" : characters,
		"AchievementCatagories" : achievement_catagories,
		"Items" : items,
		"Buildings" : buildings
	}
	
	var f = File.new()
	f.open("res://Data/Data.json", File.WRITE)
	f.store_string(JSON.print(result, "  ", true))
	f.close()
