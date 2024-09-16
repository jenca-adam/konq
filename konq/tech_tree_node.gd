extends MarginContainer
var has_focus=false
func setup(node):
	$nodePanel/node/top/SKILL_NAME.text=node["name"]
	$nodePanel/node/top/PRICE.text+=str(node["cost"])
	$nodePanel/node/bottom/sd_margin/SKILL_DESCRIPTION.text=node["description"]
	add_theme_constant_override("margin_top",get_theme_constant("margin_top")+node["margin"])
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func buy():
	pass
func _on_focus_entered():
	print("EF")
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.border_color=Color(1,1,0)
	$nodePanel.add_theme_stylebox_override("panel",sb)
	$nodePanel/node/bottom/click2buy.self_modulate.a=1
	$nodePanel/node/bottom/click2buy.disabled=false
	
	$click_catcher.hide()
	has_focus=true
func _on_focus_exited():
	var sb:StyleBoxFlat = $nodePanel.get_theme_stylebox("panel").duplicate()
	sb.border_color=Color(1,1,1)
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
	

