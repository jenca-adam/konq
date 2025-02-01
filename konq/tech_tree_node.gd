extends MarginContainer

var lines = []
var lines_incoming = []
var lines_outgoing = []
var data 
var bought = false
func get_node_from_pos(pos):
	return get_parent().get_parent().get_child(pos.x).get_child(pos.y)
func setup_real(node, tree, ntp):
	data=node
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
		append_line_incoming(line_node, req_node)
		req_node.append_line(line_node, self)
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func append_line(line,node):
	lines.append([line,node])
	lines_outgoing.append([line,node])

func append_line_incoming(line,node):
	lines.append([line,node])
	lines_incoming.append([line,node])
func buy():
	pass

func _on_focus_entered():
	if not bought and can_buy():
		var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
		sb.border_color=Color(1,1,0)
		
		
		$nodePanel.add_theme_stylebox_override("panel",sb)
		$nodePanel/node/bottom/click2buy.self_modulate.a=1
		var enable_button = func ():$nodePanel/node/bottom/click2buy.disabled=false
		get_tree().create_timer(0.1).timeout.connect(enable_button)
	$click_catcher.hide()
	expand_lines()
func expand_lines():
	for l in lines:
		var line = l[0]
		var color = Color(1,1,0,0.5)
		if l in lines_incoming:
			if l[1].bought:
				color.r=0
			else:
				color.g=0
		else:
			if bought:
				color.r=0
		get_tree().create_tween().tween_property(line,"default_color",color,0.2)
		get_tree().create_tween().tween_property(line,"width",5,0.2)
	
func recolor():
	var rec = func():
			if not can_buy() and not bought:
				var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
				sb.border_color=Color(0.7,0.7,0.7)
				#sb.bg_color=Color(0.1,0.1,0.1)
				$nodePanel/node/top/SKILL_NAME.add_theme_color_override("font_color",Color(0.6,0.6,0.6))
				$nodePanel/node/SKILL_REQUIRES.add_theme_color_override("default_color",Color(0.6,0.6,0.6))
				$nodePanel/node/bottom/sd_margin/SKILL_DESCRIPTION.add_theme_color_override("font_color",Color(0.6,0.6,0.6))
				$nodePanel/node/bottom/click2buy.disabled=true
				
				$nodePanel.add_theme_stylebox_override("panel",sb)
	get_tree().create_timer(0.1).timeout.connect(rec)
func _on_focus_exited():
	if not bought and can_buy():
		var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
		#sb.border_color=Color(1,1,1)
		get_tree().create_tween().tween_property(sb,"border_color",Color(1,1,1),0.2)
		
		$nodePanel.add_theme_stylebox_override("panel",sb)
		$nodePanel/node/bottom/click2buy.self_modulate.a=0
		var disable_button = func (): $nodePanel/node/bottom/click2buy.disabled=true
		get_tree().create_timer(0.1).timeout.connect(disable_button)
	for l in lines:
		var line = l[0]
		
		get_tree().create_tween().tween_property(line,"default_color",Color(1,1,1,0.5),0.2)
		get_tree().create_tween().tween_property(line,"width",1,0.2)
	$click_catcher.show()
	
func enter_hover():
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.bg_color=Color(0.25,0.25,0.25)
	$nodePanel.add_theme_stylebox_override("panel",sb)
func exit_hover():
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.bg_color=Color(0.196,0.196,0.196)
	$nodePanel.add_theme_stylebox_override("panel",sb)
	


func can_buy():
	return get_tree().get_root().get_child(0).money>=data["cost"]
func _buy():
	if not can_buy():
		return
	if not bought:
		bought=true
		var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
		sb.border_color=Color(0,1,0)
		sb.bg_color=Color(0,0.2,0)
		$nodePanel/node/top/SKILL_NAME.add_theme_color_override("font_color",Color(0.6,0.9,0.6))
		$nodePanel/node/SKILL_REQUIRES.add_theme_color_override("default_color",Color(0.6,0.9,0.6))
		$nodePanel/node/bottom/sd_margin/SKILL_DESCRIPTION.add_theme_color_override("font_color",Color(0.6,0.9,0.6))
		$nodePanel/node/bottom/click2buy.disabled=true
		
		$nodePanel.add_theme_stylebox_override("panel",sb)
		get_tree().get_root().get_child(0).money-=data["cost"]
		
		expand_lines()
