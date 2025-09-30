extends VBoxContainer

onready var damage_node = get_node("Damage/Amount")
onready var damage_bonus_node = get_node("Damage/Bonus")
onready var rof_node = get_node("Rof/Amount")
onready var rof_bonus_node = get_node("Rof/Bonus")

func Set(item, multipliers):
	var projectiles = item.projectiles
	var projectile_count = len(projectiles)
	var max_damage = projectiles[0].damage[1]
	var min_damage = projectiles[0].damage[0]
	var bonus = multipliers.damage - 1 if "damage" in multipliers else 0
	var bonus_sign = "+" if bonus > 0 else "-"
	var rof_bonus = (multipliers.rof - 1) * 100 if "rof" in multipliers else 0
	var rof_sign = "+" if rof_bonus > 0 else "-"
	var rof = item.rof
	
	for projectile in projectiles:
		max_damage = max(projectile.damage[1], max_damage)
		min_damage = min(projectile.damage[0], min_damage)
		
	damage_node.text = "Damage:  %d-%d %s" % [min_damage, max_damage, "(x%d)" % projectile_count if projectile_count > 1 else ""]
	damage_bonus_node.text = bonus_sign + str(max_damage * bonus)
	damage_bonus_node.add_color_override("font_color", ClientData.GetCharacter(GameHandler.character.class).color)
	damage_bonus_node.visible = bonus > 0
	
	if rof > 100 or rof_bonus != 0:
		rof_node.text = "Rate of fire:  " + str(rof) + "%"
		rof_bonus_node.text = rof_sign + str(rof_bonus) + "%"
		rof_bonus_node.add_color_override("font_color", ClientData.GetCharacter(GameHandler.character.class).color)
		rof_bonus_node.visible = rof_bonus > 0
	else:
		rof_node.visible = false
		rof_bonus_node.visible = false
