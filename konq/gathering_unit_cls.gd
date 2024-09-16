class_name GatheringUnit
var resources_map
var map
var pos
var upgrade_lvl = 0
var income = 0
var coverage_tiles = {pos: true}
var sum = 0
const game = preload("res://root.gd")
const tset: TileSet = preload("res://tilemap.tres")


func get_tile_texture(tileid):
	return tset.get_source(tileid).texture


func get_unit_id():
	pass


func get_unit_desc():
	return game.TILE_DESCRIPTIONS.get(get_unit_id(), "No description available")


func get_coverage_distances():
	return [1, 1, 1, 1, 2, 2, 2, 3]


func get_income():  # recomputes coverage too
	var cvg_area = get_coverage_distances()[upgrade_lvl]
	coverage_tiles = {pos: true}
	var last_layer = {pos: true}
	sum = resources_map[pos.y][pos.x][get_resource()]
	for dist in range(cvg_area):
		var new_layer = {}
		for sp in last_layer:
			for dir in game.DIRECTIONS:
				var p = sp + dir
				if p not in new_layer and p not in coverage_tiles:
					coverage_tiles[p] = true
					new_layer[p] = true
					sum += resources_map[p.y][p.x][get_resource()]
		last_layer = new_layer
	return sum


func get_modifiers():
	pass


func get_resource():
	pass


func refresh_values():
	income = get_income() * get_modifiers()[upgrade_lvl]


func get_material():
	pass


func get_upgrade_costs():
	pass


func get_args():
	refresh_values()
	return [
		game.TILE_NAMES[get_unit_id()],
		get_unit_desc(),
		income,
		get_tile_texture(get_unit_id()),
		get_material(),
		get_upgrade_costs()[upgrade_lvl]
	]
