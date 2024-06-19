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


var BUILDING_FISHING_SITE=["Fishing site", "Allows gathering of Fish", game.TILE_BUILDING_FISHING_SITE, always_enable]
var BUILDING_PORT=["Port", "Lets ships go to sea", game.TILE_BUILDING_PORT, always_enable]
var BUILDING_SHIPYARD=["Shipyard", "Allows the construction of ships. Must be built next to a port.", game.TILE_BUILDING_SHIPYARD, can_place_shipyard]
var AVAILABLE_BUILDINGS={
	game.TILE_WATER: [
		BUILDING_FISHING_SITE,
		
	],
	game.TILE_COASTAL: [
		BUILDING_PORT,
		BUILDING_FISHING_SITE,
		BUILDING_SHIPYARD,
	],
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
func create_entries(tile_type,tile):
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
