class_name FishingSite extends "res://gathering_unit_cls.gd"
var pos 
var map


func get_modifiers():
	return [1,1.2,1.5,1.7,2,2.3,2.5]
func get_upgrade_costs():
	return [100, 150, 200, 250, 300,400,500,600,700]
func get_unit_id():
	return 28
func get_unit_name():
	return "FishingSite"

func get_material():
	return "res://fishing.png"
func get_income():
	return 1

	
func _ready():
	pass

func _init(p,m):
	pos=p
	map=m
