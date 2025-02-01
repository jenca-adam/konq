extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	print("PRESSED")
	get_parent().grab_focus()


func _on_mouse_entered():
	print("HOVER")
	get_parent().enter_hover()
func _on_mouse_exited():
	print("HOVER")
	get_parent().exit_hover()
