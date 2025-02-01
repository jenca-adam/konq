extends HBoxContainer

@export
var image:Texture2D
@export
var varname:StringName
# Called when the node enters the scene tree for the first time.
func _ready():
	$icon.text="[img]"+image.resource_path+"[/img]"
	owner.propertyChanged.connect(_update)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update(value, nam):
	if nam==varname:
		$CONTENT.text = str(value)
