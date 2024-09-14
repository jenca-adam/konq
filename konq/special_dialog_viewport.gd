extends SubViewport

const tset=preload("res://tilemap.tres")
const game = preload("res://root.gd")
const buildings = preload("res://buildings.gd")
var CLASSMAP = {
	"LumberjacksLodge":LumberjacksLodge,
	"FishingSite":FishingSite,
}
# Called when the node enters the scene tree for the first time.

func clear():
	var entries = $sd_cont
	for entry in entries.get_children():
		if entry.name!="title":
			entries.remove_child(entry)
			entry.queue_free()
func setup_and_show(sceneN,args):
	var scene=load(sceneN).instantiate()
	scene.setup.callv(args)
	$sd_cont.add_child(scene)

func create_entries(tileid, tilepos, map):
	clear()
	setup_and_show(buildings.TILEID_SCENES[tileid], CLASSMAP[buildings.TILEID_CLASSES[tileid]].new(tilepos,map).get_args())
func get_tile_texture(tileid):
	return tset.get_source(tileid).texture
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func close():
	get_parent().hide()
	get_tree().get_root().get_node("root").dialog_closed.emit()

func _input(event):
	if Input.is_action_just_pressed("close_dialog") and get_parent().visible:
		close()
