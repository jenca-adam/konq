class_name FishingSite extends "res://gathering_unit_cls.gd"

const enums = preload("res://enums.gd")


func get_modifiers():
	return [0.4, 0.48, 0.6, 0.68, 0.8, 0.92, 1]


func get_upgrade_costs():
	return [100, 150, 200, 250, 300, 400, 500, 600, 700]


func get_unit_id():
	return 28


func get_unit_name():
	return "FishingSite"


func get_material():
	return "res://fishing.png"


func get_resource():
	return enums.RESOURCE.FISH


func _ready():
	pass


func _init(p, m, rm):
	pos = p
	map = m
	resources_map = rm
