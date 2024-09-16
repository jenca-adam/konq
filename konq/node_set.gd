extends VBoxContainer

func setup(node_set):
	for node in node_set:
		var node_node=load("res://tech_tree_node.tscn").instantiate()
		node_node.setup(node)
		add_child(node_node)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
