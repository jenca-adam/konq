extends MarginContainer

var tile
const no=preload("res://no.png")
func setup(itname,dsc,t,img, enable):
	tile=t
	$panel/margin_inner/horizontal_spacing/name/title/title_text.text=itname
	$panel/margin_inner/horizontal_spacing/name/description.text=dsc
	$panel/margin_inner/horizontal_spacing/name/title/img.texture=img
	$panel/margin_inner/horizontal_spacing/buildit.disabled=not enable[0]
	$panel/margin_inner/horizontal_spacing/buildit.text=enable[1]
	
	if not enable[0]:
		modulate.a=0.7
		modulate.r=1.1
		$panel/margin_inner/horizontal_spacing/buildit.icon=no
	
	return $panel/margin_inner/horizontal_spacing/buildit.pressed
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
