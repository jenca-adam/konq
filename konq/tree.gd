extends ScrollContainer


# Allows you to scroll a scroll container by dragging.
# Includes momentum.

var swiping = false
var swipe_start: Vector2
var swipe_mouse_start: Vector2
var swipe_mouse_times: Array[int] = []
var swipe_mouse_positions: Array[Vector2] = []
func _process(delta):
	$lines.global_position=-Vector2(scroll_horizontal, scroll_vertical)
func _input(event: InputEvent) -> void:
	print(event)
	if event is InputEventMouseButton:
		if event.pressed:
			swiping = true
			swipe_start = Vector2(scroll_horizontal, scroll_vertical)
			swipe_mouse_start = event.position
			swipe_mouse_times = [Time.get_ticks_msec()]
			swipe_mouse_positions = [swipe_mouse_start]
		else:
			swipe_mouse_times.append(Time.get_ticks_msec())
			swipe_mouse_positions.append(event.position)
			var source = Vector2(scroll_horizontal, scroll_vertical)
			var idx = swipe_mouse_times.size() - 1
			var now = Time.get_ticks_msec()
			var cutoff = now - 100
			for i in range(swipe_mouse_times.size() - 1, -1, -1):
				if swipe_mouse_times[i] >= cutoff:
					idx = i
				else:
					break
			var flick_start = swipe_mouse_positions[idx]
			var flick_duration = min(0.3, (event.position - flick_start).length() / 1000.0)
			if flick_duration > 0.0:
				var tween = get_tree().create_tween()
				var delta = event.position - flick_start
				var target = source - delta * flick_duration * 15.0
				tween.tween_property(self, "scroll_horizontal", target.x, flick_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
				tween.tween_property(self, "scroll_vertical", target.y, flick_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
				
			swiping = false
	elif swiping and event is InputEventMouseMotion:
		var delta = event.position - swipe_mouse_start
		scroll_horizontal = swipe_start.x - delta.x
		scroll_vertical = swipe_start.y - delta.y
		swipe_mouse_times.append(Time.get_ticks_msec())
		swipe_mouse_positions.append(event.position)
const TECH_TREE = [
	[
		{
			"name":"Forestry",
			"description":"Allows the construction of Lumberjack's Lodges.",
			"cost":40,
			"requires":[],
			"unlocks":[],
			"margin":0
		},
		
		{
			"name":"Ships",
			"description":"Allows the construction of Ports and Shipyards. Unlocks the Raft",
			"cost":50,
			"requires":[],
			"unlocks":["Sailing", "Shipmaking 1"],
			"margin":100,
		},
		{
			"name":"Farming",
			"description":"Allows the construction of Farms.",
			"cost":65,
			"requires":[],
			"unlocks":["Cotton", "Horses"],
			"margin":100,
		},
		
	],
	[
		{
			"name": "Woodworking",
			"description": "Allows the construction of Sawmills",
			"cost":80,
			"requires":["Forestry"],
			"unlocks":[],
			"margin":0,
		},
		{
			"name": "Shipmaking I",
			"description": "Decreases the cost of all ships by 5%",
			"cost":60,
			"requires":["Ships"],
			"unlocks":[],
			"margin":50
		},
		{
			"name": "Cotton",
			"description": "Enables the construction of Cotton Farms",
			"cost": 50,
			"requires":["Farming"],
			"unlocks":[],
			"margin":50,
			},
		{
			"name": "Horses",
			"description": "Allows the building of Stables",
			"cost": 60,
			"requires":["Farming"],
			"unlocks":[],
			"margin":0,
		}
	],
	[
		{
			"name":"Paper",
			"description": "<TODO>",
			"cost": 70,
			"requires":["Woodworking"],
			"unlocks":[],
			"margin":0
		},
		{
			"name": "Shipmaking II",
			"description": "Decreases the cost of all ships by 10%",
			"cost":60,
			"requires":["Shipmaking I"],
			"unlocks":[],
			"margin":50
		},
		{
			"name": "Sailing",
			"description": "Unlocks the Yacht",
			"cost":75,
			"requires":["Shipmaking I", "Cotton"],
			"unlocks":[],
			"margin":0,
		},
		{
			"name": "Carriages",
			"description": "Allows the construction of Carriages",
			"cost": 90,
			"requires":["Horses","Woodworking"],
			"unlocks":[],
			"margin":50
		}
	]
	
]
var NAME_TO_POS_MAP = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	
	var index=0
	for level in TECH_TREE:
		var li = 0
		for node in level:
			NAME_TO_POS_MAP[node["name"]]=Vector2i(index,li)
			li+=1
		var node_set = load("res://node_set.tscn").instantiate()
		
		$panel/margin/tree_items.add_child(node_set)
		node_set.setup(level,TECH_TREE,NAME_TO_POS_MAP)
		index+=1
	print(NAME_TO_POS_MAP)
func recolor():
	for child in $panel/margin/tree_items.get_children():
		for node in child.get_children():
			node.recolor()
# Called every frame. 'delta' is the elapsed time since the previous frame.
