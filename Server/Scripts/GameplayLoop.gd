extends Node

var island_preloads = {}
var at_spire = false
var bosses_status = {
	"oranix" : true,
	"vajira" : true,
	"raa'sloth" : true,
	"salazar" : false,
}

func CreateIslandTemplate(map_size = Vector2(750,750), special=null):
	var island_instance = load("res://Scenes/SupportScenes/Island/Island.tscn").instance()
	if special:
		island_instance = load("res://Scenes/SupportScenes/Island/SpecialIsland.tscn").instance()
		island_instance.which = special
	
	island_instance.server = get_node("/root/Server")
	island_instance.map_size = map_size
	island_instance.GenerateIslandMap()
	if GameplayLoop.island_preloads.has(map_size):
		GameplayLoop.island_preloads[map_size].append(island_instance)
	else:
		GameplayLoop.island_preloads[map_size] = [island_instance]

func Update():
	var oranix = bosses_status["oranix"]
	var vajira = bosses_status["vajira"]
	var raasloth = bosses_status["raa'sloth"]
	var salazar = bosses_status["salazar"]
	
	var vessels_dead = not oranix and not vajira and not raasloth and not at_spire
	var salazar_dead = not salazar and at_spire
	
	var server = get_node("/root/Server")
	var nexus = server.nexus
	
	if vessels_dead:
		at_spire = true
		bosses_status = {
			"oranix" : false,
			"vajira" : false,
			"raa'sloth" : false,
			"salazar" : true,
		}
		
		nexus.taken_points = []
		nexus.OpenPortal("island", nexus.GetBoatSpawnpoints(), Vector2(750,750), "salazar")
	
	if salazar_dead:
		at_spire = false
		bosses_status = {
			"oranix" : true,
			"vajira" : true,
			"raa'sloth" : true,
			"salazar" : false,
		}
		
		nexus.taken_points = []
		nexus.OpenPortal("island", nexus.GetBoatSpawnpoints(), Vector2(750,750), "oranix")
		nexus.OpenPortal("island",  nexus.GetBoatSpawnpoints(), Vector2(750,750), "vajira")
		nexus.OpenPortal("island", nexus.GetBoatSpawnpoints(), Vector2(750,750), "raa'sloth")
		
		#var special_island_open = false
		#for node in server.get_node("Instances/nexus").get_children():
			#if "island" in node.name and node.ruler == "pumpkin_tyrant":
				#special_island_open = true
		#if not special_island_open:
			#server.get_node("Instances/nexus").OpenPortal("special_island", ["nexus"], server.get_node("Instances/nexus").GetBoatSpawnpoints(), Vector2(501,501), "pumpkin_tyrant", "halloween")
