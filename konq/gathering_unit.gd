extends Panel
const HOWMUCH_FMT = "This %s makes %d [img]%s[/img] per turn."


func setup(unit_name, unit_desc, income, unit_img, material_img, upgrade_cost):
	$vbox/title/UNIT_NAME.text = unit_name
	$vbox/title/UNIT_IMG.texture = unit_img
	$vbox/MarginContainer/Panel/MarginContainer/HBoxContainer/UNIT_IMG.texture = unit_img
	$vbox/MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/UNIT_DESC.text = unit_desc
	$vbox/MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer2/B_UPGRADE.text = (
		"%s Upgrade" % upgrade_cost
	)
	$vbox/MarginContainer/Panel/MarginContainer/HBoxContainer/VBoxContainer/UNIT_HOWMUCH.text = (
		HOWMUCH_FMT % [unit_name, income, material_img]
	)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
