extends SubViewport
const game = preload("res://root.gd")
const tset:TileSet = preload("res://tilemap.tres")

func always_enable(tile):
	return [true, "Build"]
func can_place_shipyard(tile):
	
	for delta in game.DIRECTIONS_NONCARDINAL:
		var new_t=tile+delta
		if $/root/root.buildings_map[new_t.y][new_t.x] == game.TILE_BUILDING_PORT:
			return [true, "Build"]
	return [false, "Not next to a Port"]
var CAN_PLACE={
	game.TILE_BUILDING_SHIPYARD: can_place_shipyard
}
func create_building_struct(tile_id):
	return [game.TILE_NAMES[tile_id], game.TILE_DESCRIPTIONS.get(tile_id, "No description available."), tile_id, CAN_PLACE.get(tile_id, always_enable)]
@onready
var BUILDING_FISHING_SITE=create_building_struct(game.TILE_BUILDING_FISHING_SITE)
@onready
var BUILDING_PORT=create_building_struct(game.TILE_BUILDING_PORT)
@onready
var BUILDING_LUMBERJACKS_LODGE=create_building_struct(game.TILE_BUILDING_LUMBERJACKS_LODGE)
@onready
var BUILDING_SHIPYARD=create_building_struct(game.TILE_BUILDING_SHIPYARD)
@onready
var BUILDING_OIL_WELL=create_building_struct(game.TILE_BUILDING_OIL_WELL)
@onready
var BUILDING_OIL_RIG=create_building_struct(game.TILE_BUILDING_OIL_RIG)
@onready
var BUILDING_QUARRY=create_building_struct(game.TILE_BUILDING_QUARRY)
@onready
var BUILDING_GOLD_MINE=create_building_struct(game.TILE_BUILDING_GOLD_MINE)
@onready
var BUILDING_IRON_MINE=create_building_struct(game.TILE_BUILDING_IRON_MINE)
@onready
var BUILDING_COAL_MINE=create_building_struct(game.TILE_BUILDING_COAL_MINE)
@onready
var AVAILABLE_BUILDINGS={
	game.TILE_WATER: [
		BUILDING_FISHING_SITE,
		BUILDING_OIL_RIG
		
	],
	game.TILE_COASTAL: [
		BUILDING_PORT,
		BUILDING_FISHING_SITE,
		BUILDING_SHIPYARD,
		BUILDING_OIL_RIG,
	],
	game.TILE_FOREST: [
		BUILDING_LUMBERJACKS_LODGE,
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_JUNGLE: [
		BUILDING_LUMBERJACKS_LODGE,
		BUILDING_OIL_WELL
	],
	game.TILE_DESERT: [
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_GRASS: [
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_MARSHES: [
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_PLAINS: [
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_SAVANNAH: [
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_SNOW: [
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	],
	game.TILE_TUNDRA: [
		
		BUILDING_OIL_WELL,
		BUILDING_GOLD_MINE,
		BUILDING_IRON_MINE,
		BUILDING_COAL_MINE, BUILDING_QUARRY
	
	]
	}
func get_tile_texture(tileid):
	return tset.get_source(tileid).texture
func add_entry(entry_name, entry_dsc, entry_tileid, enabled):
	var texture:CompressedTexture2D=get_tile_texture(entry_tileid)
	print(texture)
	var entry=load("res://build_dialog_entry.tscn").instantiate()
	var sgn:Signal=entry.setup(entry_name,entry_dsc,entry_tileid,texture,enabled)
	sgn.connect(func():close();get_tree().get_root().get_node("root").build_building.emit(entry_tileid))
	$scroll/entries.add_child(entry)
func create_entries(tile_type,tile, map):
	print(tile_type)
	var entries=$scroll/entries
	for entry in entries.get_children():
		if entry.name!="title":
			entries.remove_child(entry)
			entry.queue_free()
	print(AVAILABLE_BUILDINGS,tile_type)
	if AVAILABLE_BUILDINGS.has(tile_type):
		for build in AVAILABLE_BUILDINGS[tile_type]:
			print(build)
			add_entry(build[0],build[1],build[2],build[3].call(tile))
func close():
	get_parent().hide()
	get_tree().get_root().get_node("root").dialog_closed.emit()
func _ready():pass
	#create_entries(0)

func _input(event):
	if Input.is_action_just_pressed("close_dialog") and get_parent().visible:
		close()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cancel_build_pressed():
	close()
