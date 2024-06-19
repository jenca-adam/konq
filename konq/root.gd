extends Node2D
var map=[]
var buildings_map=[]
var terrain_map=[]
var map_node_zoom_0_pos
var tileSize
var posx
var posy
var consonants="bcdfghjklmnpqrstvwxzčćçďĺľñňŕřśšťžź"
var vowels="aǎâäãåąàȧáeéěẽěêĕęèėiíǐĩǐîĭįìıíïoóǒôõǫòȯőöuúǔũǔûŭůųùúűü"
var map_node:TileMap
var currentTile
var pickingAnIsland=true
var currentIsland
var colonizedIslands=[]
var mapActive=true
var zoom = 1
signal dialog_closed
signal build_building(building:int)
const DIRECTIONS=[
	Vector2i(0,-1),
	Vector2i(1,0),
	Vector2i(0,1),
	Vector2i(-1,0)
]
const DIRECTIONS_NONCARDINAL=[
	Vector2i(0,-1),
	Vector2i(1,-1),
	Vector2i(1,0),
	Vector2i(1,1),
	Vector2i(0,1),
	Vector2i(-1,1),
	Vector2i(-1,0),
	Vector2i(-1,-1)
]
const CLIMATE_TROPICAL=0 # jungles, deserts, savannahs, grass
const CLIMATE_MODERATE=1 # forests, plains, grass
const CLIMATE_COLD=2 # forests, tundra, plains, snow

const TERRAIN_FLAT=0 # 
const TERRAIN_HILLY=1 # hills
const TERRAIN_ALPINE=2 # hills, mountains

const TILE_WATER=0
const TILE_GRASS=1
const TILE_COASTAL=2
const TILE_FOREST=3
const TILE_JUNGLE=4
const TILE_PLAINS=5
const TILE_SAVANNAH=6
const TILE_DESERT=7
const TILE_MOUNTAINS=8
const TILE_SNOW=9
const TILE_TUNDRA=10
const TILE_ICE=11
const TILE_MARSHES=12
const TILE_BORDER_E=13
const TILE_BORDER_S=14
const TILE_BORDER_W=15
const TILE_BORDER_N=16
const TILE_BORDER_NW=17
const TILE_BORDER_NE=18
const TILE_BORDER_SE=19
const TILE_BORDER_SW=20
const TILE_BORDER_EW=21
const TILE_BORDER_NS=22
const TILE_BORDER_NEW=23
const TILE_BORDER_NES=24
const TILE_BORDER_ESW=25
const TILE_BORDER_NSW=26
const TILE_BORDER_EMPTY=27
const TILE_BUILDING_FISHING_SITE=28
const TILE_BUILDING_PORT=29
const TILE_BUILDING_SHIPYARD=30
const TILE_HILLS_OVERLAY=61
const TILE_MOUNTAINS_OVERLAY=62
const TILE_SELECTED=63
const TILE_EMPTY=64
const DIR_TO_BORDER_MAP = {  # nesw
	Vector4i(0, 0, 0, 0): TILE_BORDER_EMPTY,
	Vector4i(1, 0, 0, 0): TILE_BORDER_N,
	Vector4i(0, 1, 0, 0): TILE_BORDER_E,
	Vector4i(0, 0, 1, 0): TILE_BORDER_S,
	Vector4i(0, 0, 0, 1): TILE_BORDER_W,
	Vector4i(1, 1, 0, 0): TILE_BORDER_NE,
	Vector4i(1, 0, 1, 0): TILE_BORDER_NS,
	Vector4i(1, 0, 0, 1): TILE_BORDER_NW,
	Vector4i(0, 1, 1, 0): TILE_BORDER_SE,
	Vector4i(0, 1, 0, 1): TILE_BORDER_EW,
	Vector4i(0, 0, 1, 1): TILE_BORDER_SW,
	Vector4i(1, 1, 1, 0): TILE_BORDER_NES,
	Vector4i(1, 1, 0, 1): TILE_BORDER_NEW,
	Vector4i(1, 0, 1, 1): TILE_BORDER_NSW,
	Vector4i(0, 1, 1, 1): TILE_BORDER_ESW,
	Vector4i(1, 1, 1, 1): TILE_SELECTED,
}
#const TILE_NAMES = {TILE_WATER:"Water", TILE_GRASS:"Grass", TILE_COSTAL:"Coastal waters", TILE_FOREST:"Forest", TILE_JUNGLE:"Jungle", TILE_PLAINS:"Plains",
const TILE_NAMES = {
	TILE_WATER: "Water",
	TILE_GRASS: "Grass",
	TILE_COASTAL: "Coastal waters",
	TILE_FOREST: "Forest",
	TILE_JUNGLE: "Jungle",
	TILE_PLAINS: "Plains",
	TILE_SAVANNAH: "Savannah",
	TILE_DESERT: "Desert",
	TILE_MOUNTAINS: "Mountains",
	TILE_SNOW: "Snow",
	TILE_TUNDRA: "Tundra",
	TILE_ICE: "Ice",
	TILE_MARSHES: "Marshes",
	TILE_BUILDING_FISHING_SITE: "Fishing Site",
	TILE_BUILDING_PORT: "Port",
	TILE_BUILDING_SHIPYARD: "Shipyard"
}
const CLIMATE_NAMES={
	CLIMATE_COLD:"Cold",
	CLIMATE_MODERATE:"Temperate",
	CLIMATE_TROPICAL:"Tropical"
}
const no = preload("res://no.png")
var tileToIslandMap={}
var islandDetails=[]
@export
var mapSize:int
@export
var minIslandIterations:int
@export
var maxIslandIterations:int
@export
var minNIslands:int
@export
var maxNIslands:int
func _input(event):
	if mapActive:
		if Input.is_action_pressed("map_move_up"):
			#if posy>ceil($map_viewport.size.y/zoom/tileSize/2.0):
			map_node.translate(Vector2(0,tileSize))
			posy-=1
		if Input.is_action_pressed("map_move_down"):
			#print(map_node.position.y,-mapSize*tileSize)
			#if map_node.position.y>((-mapSize+1)*tileSize+get_viewport_rect().size.y/zoom):
			map_node.translate(Vector2(0,-tileSize))
			posy+=1
		if Input.is_action_just_pressed("regenerate"):
			
			map_node.clear()
			generate_map()
		if Input.is_action_pressed("map_move_right"):
			#print(mapSize-posx)
			#print($map_viewport.size.x*zoom/tileSize/2.0)
			#if (mapSize-posx)>ceil($map_viewport.size.x/zoom/tileSize/2.0):
			map_node.translate(Vector2(-tileSize,-0))
			posx+=1
		if Input.is_action_pressed("map_move_left"):
			#print($map_viewport.size.x/zoom/tileSize/2.0)
			
			map_node.translate(Vector2(tileSize,0))
			posx-=1
		if Input.is_action_just_pressed("map_zoom_reset"):
			zoom=1
			$map_viewport/cam.zoom=Vector2(zoom,zoom)
		if Input.is_action_just_pressed("map_zoom_full"):
			#map_node.position=map_node_zoom_0_pos
			zoom=(864.0/tileSize)/mapSize
			$map_viewport/cam.zoom=Vector2(zoom,zoom)
		if Input.is_action_pressed("map_zoom_in"):
			zoom=min(zoom*1.1,10)
			$map_viewport/cam.zoom=Vector2(zoom,zoom)
			
			#print(map_node.position)
		if Input.is_action_pressed("map_zoom_out"):
			
			zoom=max(zoom/1.1,0.05)
			#map_node.position=lerp(map_node.position,Vector2((-mapSize/2)*tileSize,(-mapSize/2)*tileSize),(0.09/zoom))
			$map_viewport/cam.zoom=Vector2(zoom,zoom)
		if event is InputEventMouseButton: 
			if event.button_index==1 and event.pressed and Rect2($TextureRect.position, $TextureRect.size).has_point(event.position):
				#print(tileSize)
				
				var ct = Vector2i(floor((event.global_position/zoom-$TextureRect.position/zoom+(Vector2(posx-$map_viewport.size.x/zoom/tileSize/2.0,posy-$map_viewport.size.y/zoom/tileSize/2.0)*tileSize))/tileSize))
				if ct==currentTile:
					currentTile=null
					map_node.clear_layer(3)
					map_node.clear_layer(4)
				else:
					if 0<=ct.x and ct.x<mapSize and 0<=ct.y and ct.y<mapSize:
						currentTile=ct
						map_node.clear_layer(4)
						map_node.clear_layer(3)
						map_node.set_cell(4,currentTile,TILE_SELECTED,Vector2i(0,0))
		update_labels()
func empty_map(m, fill=0):
	m=[]
	for i in range(mapSize):
		var map_row=[]
		for j in range(mapSize):
			map_row.append(fill)
		m.append(map_row)
	return m
func add_ice(m):
	for x in range(mapSize):
		var upper_dist=randi_range(20,25)
		var lower_dist=randi_range(20,25)
		for y in range(upper_dist):
			m[y][x]=TILE_ICE
		for y in range(mapSize-lower_dist,mapSize):
			m[y][x]=TILE_ICE
func add_coastal(lg,m):
	for shore in lg:
		for dir in DIRECTIONS:
			var w=shore+dir
			if 0<=w.y and w.y<mapSize and 0<=w.x and w.x<mapSize and m[w.y][w.x]==0 and randi_range(0,2)>0:
				m[w.y][w.x]=2
func highlight_island(tl,m):
	
	for tile in tl:
		var surr=Vector4i(0,0,0,0)
		var index=0
		for dir in DIRECTIONS:
			var w=tile+dir
			if w.y<0 or w.y>=mapSize or 0>w.x or w.x>mapSize or w not in tl:
				surr[index]=1
			index+=1
		map_node.set_cell(3,tile,DIR_TO_BORDER_MAP[surr],Vector2i(0,0))
func add_subislands(tl,tp,it,m,cl):
	var ns
	if it<7:
		return
	elif it<10:
		ns=randi_range(0,1)
	elif it<12:
		ns=randi_range(1,1)
	else:
		ns=randi_range(1,2)
	if len(tp)>1:
		ns+=1
	print("subi",ns)
	for i in range(ns):
		var start=tl[randi_range(0,tl.size()-1)]
		var type = tp[randi_range(0, tp.size()-1)]
		var iterations=randi_range(2,(5 if it>12 else (4 if it>10 else 3)))
		var subisland_tiles=[start]
		var nts
		for a in range(iterations):
			
			for tile in subisland_tiles:
				var new_tile
				nts=[]
				var dirs=DIRECTIONS.duplicate()
				dirs.shuffle()
				for direction in dirs:
					var dirc=DIRECTIONS[randi_range(0,len(DIRECTIONS)-1)]
					new_tile=tile+dirc
					if new_tile in tl:
						break
				
				if new_tile not in tl:
					continue
				if map[new_tile.y][new_tile.x]in[TILE_PLAINS, TILE_GRASS, TILE_DESERT] and type==TILE_WATER:
					if cl==CLIMATE_MODERATE:
						m[new_tile.y][new_tile.x]=TILE_MARSHES
				
					#print("marshes")
				else:
					m[new_tile.y][new_tile.x]=type
				nts.append(tile)
				nts.append(new_tile)
				
		subisland_tiles=nts
		if cl==CLIMATE_TROPICAL and type==TILE_WATER:
			for stile in subisland_tiles:
				for dir in DIRECTIONS:
					var w=stile+dir
					if w in tl and w not in subisland_tiles and  m[w.y][w.x]==TILE_DESERT :
						m[w.y][w.x]=TILE_FOREST
						
			
func generate_name():
	var nam=""
	for i in range(randi_range(3,7)):
		if i%2==0:
			nam+=consonants[randi_range(0,len(consonants)-1)]
			if i==0:
				nam=nam.to_upper()
		else:
			nam+=vowels[randi_range(0,len(vowels)-1)]
	print(nam)
	return nam
func add_island(m,tm):
	print("island")
	var island_id=len(islandDetails)
	var island_start=Vector2i(randi_range(0,mapSize-1),randi_range(0,mapSize-1))
	m[island_start.y][island_start.x]=1
	var island_tiles=[island_start]
	var iterations = randi_range(minIslandIterations,maxIslandIterations)
	var lgtiles=[]
	var island_name=generate_name()
	var latitude=abs(island_start.y-(mapSize/2))
	var climate
	if latitude<mapSize/6:
		climate= CLIMATE_TROPICAL
	elif latitude<2*mapSize/6:
		climate=CLIMATE_MODERATE
	else:
		climate=CLIMATE_COLD
	var terrain=randi_range(0,2)
	var reid=false
	for it in range(iterations):
		
		var ntiles=island_tiles.duplicate()
		lgtiles=[]
		for tile in island_tiles:
			var new_tile
			var dirs=DIRECTIONS.duplicate()
			dirs.shuffle()
			for direction in dirs:
				
				new_tile=tile+direction
				if 0<=new_tile.x and new_tile.x<mapSize and 0<=new_tile.y and new_tile.y<mapSize:
					break
			m[new_tile.y][new_tile.x]=1
			if tileToIslandMap.has(new_tile) and new_tile not in island_tiles and new_tile not in ntiles:
				island_id=tileToIslandMap[new_tile]
				#print(new_tile,island_tiles,island_id)
				reid=true
			if new_tile not in ntiles:
				ntiles.append(new_tile)
			lgtiles.append(new_tile)
			
			
			tileToIslandMap[new_tile]=island_id
			
		island_tiles=ntiles
	
	var dry=randi_range(0,1)
	if reid:
		print("merge {0} with {1}".format([island_name,islandDetails[island_id]["name"]]))
		dry=islandDetails[island_id]["dry"]
		terrain=islandDetails[island_id]["terrain"]
		climate=islandDetails[island_id]["climate"]
		island_name=islandDetails[island_id]["name"]
		islandDetails[island_id]["tiles"]+=(island_tiles)
		island_tiles=islandDetails[island_id]["tiles"]
	var subisland_types=[TILE_WATER] if not dry else [TILE_SAVANNAH]
	for tile in island_tiles: # first pass (plains, 
		if reid:
			tileToIslandMap[tile]=island_id
		if climate==CLIMATE_COLD:
			m[tile.y][tile.x]=TILE_SNOW
			subisland_types=[TILE_TUNDRA, TILE_FOREST]
		if climate==CLIMATE_TROPICAL:
			subisland_types=[TILE_WATER, TILE_WATER, TILE_PLAINS, TILE_SAVANNAH]
			var is_savannah=true
			var is_2nd=true
			var is_jungle=true
			
			for d in DIRECTIONS:
				var neighb_tile=tile+d
				
				if 0<=neighb_tile.x and neighb_tile.x<mapSize and 0<=neighb_tile.y and neighb_tile.y<mapSize:
					if m[neighb_tile.y][neighb_tile.x]not in [TILE_GRASS, TILE_SAVANNAH]:
						is_savannah=false
					if not is_savannah:
						break
			if is_savannah:
				m[tile.y][tile.x]=TILE_SAVANNAH
		if climate==CLIMATE_MODERATE:
			var is_plains=true
			
			for d in DIRECTIONS:
				var neighb_tile=tile+d
				if 0<=neighb_tile.x and neighb_tile.x<mapSize and 0<=neighb_tile.y and neighb_tile.y<mapSize:
					if m[neighb_tile.y][neighb_tile.x]not in [TILE_GRASS, TILE_PLAINS]:
						is_plains=false
					
					if not is_plains:
						break
			if is_plains:
				m[tile.y][tile.x]=TILE_PLAINS
	for tile in island_tiles:
		if climate==CLIMATE_TROPICAL:
			var is_2nd=true
			for d in DIRECTIONS:
				var neighb_tile=tile+d
				
				if 0<=neighb_tile.x and neighb_tile.x<mapSize and 0<=neighb_tile.y and neighb_tile.y<mapSize:
					if dry and m[neighb_tile.y][neighb_tile.x]not in [TILE_SAVANNAH, TILE_DESERT]:
						is_2nd=false
					if not dry and m[neighb_tile.y][neighb_tile.x] not in [TILE_SAVANNAH, TILE_FOREST]:
						is_2nd=false
					if not is_2nd:
						break
			if is_2nd and dry:
				m[tile.y][tile.x]=TILE_DESERT
			elif is_2nd:
				m[tile.y][tile.x]=TILE_FOREST
		if climate==CLIMATE_MODERATE:
			var is_forest=true
			for d in DIRECTIONS:
				var neighb_tile=tile+d
				
				if 0<=neighb_tile.x and neighb_tile.x<mapSize and 0<=neighb_tile.y and neighb_tile.y<mapSize:
					if m[neighb_tile.y][neighb_tile.x]not in [TILE_PLAINS, TILE_FOREST]:
						is_forest=false
						break
			if is_forest:
				m[tile.y][tile.x]=TILE_FOREST
	if not dry and climate==CLIMATE_TROPICAL:
		for tile in island_tiles:
			var is_jungle=true
			for d in DIRECTIONS:
				var neighb_tile=tile+d
				
				if 0<=neighb_tile.x and neighb_tile.x<mapSize and 0<=neighb_tile.y and neighb_tile.y<mapSize:
					if m[neighb_tile.y][neighb_tile.x]not in [TILE_JUNGLE, TILE_FOREST]:
						is_jungle=false
						break
			if is_jungle:
				m[tile.y][tile.x]=TILE_JUNGLE
	add_coastal(lgtiles,m)
	add_subislands(island_tiles,subisland_types,iterations,m,climate)
	
	"""for tile in island_tiles:
		if terrain==TERRAIN_HILLY:
			#print("hh")
			var is_hilly=true
			for d in DIRECTIONS:
				var neighb_tile=tile+d
				if neighb_tile in island_tiles:
					if m[neighb_tile.y][neighb_tile.x]in[TILE_GRASS, TILE_COASTAL, TILE_WATER]:
						is_hilly=false
						break
					
			if is_hilly and m[tile.y][tile.x]!=TILE_WATER:
				if randi_range(0,16)==0:
					print("H")
					tm[tile.y][tile.x]=TILE_HILLS_OVERLAY"""
	var details={"id":island_id,"tiles":island_tiles,"iterations":iterations,"center_tile":island_start,"terrain":terrain,"climate":climate,"name":island_name,"dry":dry}
	#print(details)
	islandDetails.append(details)
func generate_map():
	tileToIslandMap={}
	islandDetails=[]
	map=empty_map(map)
	add_ice(map)
	#print(map)
	terrain_map=empty_map(terrain_map,TILE_EMPTY)
	buildings_map=empty_map(buildings_map,-1)
	for i in range(randi_range(minNIslands, maxNIslands)):
		add_island(map,terrain_map)
	for i in range(mapSize):
		for j in range(mapSize):
			map_node.set_cell(0,Vector2i(j,i),map[i][j],Vector2i(0,0))
			map_node.set_cell(1,Vector2i(j,i),terrain_map[i][j],Vector2i(0,0))
func adjacentToIslands(islands,tile):
	
	for neighb in DIRECTIONS:
		var ntl = Vector2i(tile+neighb)
		if tileToIslandMap.has(ntl):
			if tileToIslandMap[ntl] in islands:
				
				return true
	return false
func update_labels():
	$labels/labels_left/pos.text="x: "+str(posx)+"; y: "+str(posy)
	$labels/labels_right/zoom_label.text="zoom: "+str(zoom)
	
	
	
	if tileToIslandMap.has(currentTile):
		#print(currentTile)
		
		currentIsland=tileToIslandMap[currentTile]
		highlight_island(islandDetails[tileToIslandMap[currentTile]]["tiles"],map)
		$labels/labels_right/island_name_label.text="island name: "+islandDetails[tileToIslandMap[currentTile]]["name"]+"\n"+\
		"island climate: "+CLIMATE_NAMES[(islandDetails[tileToIslandMap[currentTile]]["climate"])]
		if pickingAnIsland:
			$labels/labels_right/start_button.show()
			$labels/labels_right/start_button.disabled=false
	else:
		$labels/labels_right/island_name_label.text=""
		$labels/labels_right/start_button.hide()
		$labels/labels_right/start_button.disabled=true
	
	if currentTile!=null:
		$labels/labels_right/action_buttons/action_buttons_row_2/info_button.disabled=false
		
		print(buildings_map[currentTile.y][currentTile.x])
		if buildings_map[currentTile.y][currentTile.x]==-1:
			$labels/labels_right/action_buttons/action_buttons_row_1/build_button.disabled=false
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.disabled=true
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.icon=no
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.text="Special"
			$labels/labels_right/action_buttons/action_buttons_row_1/demolish_button.disabled=true
		else:
			$labels/labels_right/action_buttons/action_buttons_row_1/demolish_button.disabled=false
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.disabled=false
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.icon=$build_dialog_container/build_dialog_viewport.get_tile_texture(buildings_map[currentTile.y][currentTile.x])
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.text=TILE_NAMES[buildings_map[currentTile.y][currentTile.x]]
			$labels/labels_right/action_buttons/action_buttons_row_1/build_button.disabled=true
		$labels/labels_right/tile_type_label.text="type of tile: "+TILE_NAMES[map[currentTile.y][currentTile.x]]
		if not pickingAnIsland and not adjacentToIslands(colonizedIslands,currentTile):
			
			$labels/labels_right/action_buttons/action_buttons_row_1/build_button.disabled=true
			$labels/labels_right/action_buttons/action_buttons_row_2/special_button.disabled=true
	else:
		$labels/labels_right/action_buttons/action_buttons_row_1/build_button.disabled=true
		$labels/labels_right/action_buttons/action_buttons_row_1/demolish_button.disabled=true
		$labels/labels_right/action_buttons/action_buttons_row_2/info_button.disabled=true
		$labels/labels_right/action_buttons/action_buttons_row_2/special_button.disabled=true
# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_viewport_rect().size)
	map_node=$map_viewport/cam/map
	tileSize=map_node.tile_set.tile_size.x
	map_node_zoom_0_pos=Vector2((-mapSize/2)*tileSize,(-mapSize/2)*tileSize)
	map_node.translate(map_node_zoom_0_pos)
	posx=mapSize/2
	posy=mapSize/2
	update_labels()
	generate_map()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func always_enable(tile):
	return true

func _on_start_button_pressed():
	if pickingAnIsland:
		pickingAnIsland=false
		$labels/labels_right/start_button.hide()
		$labels/labels_right/action_buttons.show()
		colonizedIslands.append(currentIsland)


func _on_build_button_pressed():
	print($build_dialog_container/build_dialog_viewport.create_entries)
	$build_dialog_container/build_dialog_viewport.create_entries(map[currentTile.y][currentTile.x], currentTile)
	$build_dialog_container.show()
	mapActive=false


func _on_dialog_closed():
	mapActive=true


func _on_build_building(building):
	buildings_map[currentTile.y][currentTile.x]=building
	map_node.set_cell(2,currentTile,building,Vector2i(0,0))
	update_labels()


func _on_demolish_button_pressed():
	buildings_map[currentTile.y][currentTile.x]=-1
	map_node.set_cell(2,currentTile,-1)
	update_labels()
