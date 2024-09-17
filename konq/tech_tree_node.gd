extends MarginContainer
var has_focus=false
var lines = []
func get_node_from_pos(pos):
	return get_parent().get_parent().get_child(pos.x).get_child(pos.y)
func setup_real(node, tree, ntp):
	
	if node["requires"]:
		
		var req_names=[]
		var req_positions=[]
		for req_index in node["requires"]:
			req_names.append(req_index)
			
			"""var line_node = Line2D.new()
			line_node.default_color=Color(randf(), randf(), randf())
			print(node["name"], req_index, line_node.default_color, req_node.global_position, global_position, req_node.size, size, " LINE")
			
			line_node.add_point(req_node.global_position+req_node.size)
			line_node.add_point(global_position)
			print(line_node.points, " LINE")"""
			
		$nodePanel/node/SKILL_REQUIRES.text="Requires: "+", ".join(req_names)
	else:
		$nodePanel/node/SKILL_REQUIRES.text=""
	
	$nodePanel/node/top/SKILL_NAME.text=node["name"]
	$nodePanel/node/top/PRICE.text+=str(node["cost"])
	$nodePanel/node/bottom/sd_margin/SKILL_DESCRIPTION.text=node["description"]
	add_theme_constant_override("margin_top",get_theme_constant("margin_top")+node["margin"])
	
func setup(node, tree, ntp):
	setup_real(node, tree, ntp)

	call_deferred("draw_lines", node,tree,ntp)
func draw_lines(node,tree,ntp):
	
	var np = $nodePanel
	for req_index in node["requires"]:
		var line_node=Line2D.new()
		var req_node:MarginContainer= get_node_from_pos(ntp[req_index])
		var rp = req_node.find_child("nodePanel")
		line_node.add_point(rp.global_position+rp.size*Vector2(1,0.5))
		line_node.add_point(np.global_position+np.size*Vector2(0,0.5))
		line_node.width=1
		line_node.default_color=Color(1,1,1,0.5)
		get_parent().get_parent().get_parent().get_parent().get_parent().get_node("lines").add_child(line_node)
		append_line(line_node)
		req_node.append_line(line_node)
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func append_line(line):
	lines.append(line)
func buy():
	pass
func _on_focus_entered():
	print("EF")
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.border_color=Color(1,1,0)
	
	for line in lines:
		
		get_tree().create_tween().tween_property(line,"default_color",Color(1,1,0,0.5),0.2)
		get_tree().create_tween().tween_property(line,"width",5,0.2)
	$nodePanel.add_theme_stylebox_override("panel",sb)
	$nodePanel/node/bottom/click2buy.self_modulate.a=1
	$nodePanel/node/bottom/click2buy.disabled=false
	
	$click_catcher.hide()
	has_focus=true
func _on_focus_exited():
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	#sb.border_color=Color(1,1,1)
	get_tree().create_tween().tween_property(sb,"border_color",Color(1,1,1),0.2)
	for line in lines:
		
		get_tree().create_tween().tween_property(line,"default_color",Color(1,1,1,0.5),0.2)
		get_tree().create_tween().tween_property(line,"width",1,0.2)
	$nodePanel.add_theme_stylebox_override("panel",sb)
	$nodePanel/node/bottom/click2buy.self_modulate.a=0
	$nodePanel/node/bottom/click2buy.disabled=true
	$click_catcher.show()
	has_focus=false

func enter_hover():
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.bg_color=Color(0.25,0.25,0.25)
	$nodePanel.add_theme_stylebox_override("panel",sb)
func exit_hover():
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.bg_color=Color(0.196,0.196,0.196)
	$nodePanel.add_theme_stylebox_override("panel",sb)
	

