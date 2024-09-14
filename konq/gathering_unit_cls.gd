class_name GatheringUnit

var upgrade_lvl = 0
var income = 0
const game = preload("res://root.gd")
const tset:TileSet = preload("res://tilemap.tres")

func get_tile_texture(tileid):
	return tset.get_source(tileid).texture
func get_unit_id():
	pass
func get_unit_desc():
	return game.TILE_DESCRIPTIONS.get(get_unit_id(),"No description available")
func get_income():
	pass
func get_modifiers():
	pass
func refresh_values():
	income = get_income()*get_modifiers()[upgrade_lvl]
func get_material():
	pass
func get_upgrade_costs():
	pass
func get_args():
	refresh_values()
	return [game.TILE_NAMES[get_unit_id()], get_unit_desc(), income, get_tile_texture(get_unit_id()), get_material(), get_upgrade_costs()[upgrade_lvl] ]
