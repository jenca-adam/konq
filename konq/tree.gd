extends ScrollContainer


# Allows you to scroll a scroll container by dragging.
# Includes momentum.

var swiping = false
var swipe_start: Vector2
var swipe_mouse_start: Vector2
var swipe_mouse_times: Array[int] = []
var swipe_mouse_positions: Array[Vector2] = []

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
			"name":"Ships",
			"description":"Allows the construction of Ports and Shipyards. Unlocks the Raft",
			"cost":50,
			"requires":[],
			"unlocks":[0, 1],
			"margin":0,
		}
	],
	[
		{
			"name": "Sailing",
			"description": "Unlocks the Yacht",
			"cost":75,
			"requires":[0],
			"unlocks":[],
			"margin":0
		},
		{
			"name": "Shipmaking I",
			"description": "Decreases the cost of all ships by 15%",
			"cost":60,
			"requires":[0],
			"unlocks":[],
			"margin":20
		}
	]
	
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for level in TECH_TREE:
		var node_set = load("res://node_set.tscn").instantiate()
		node_set.setup(level)
		$panel/margin/tree_items.add_child(node_set)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
