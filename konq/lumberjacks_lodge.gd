class_name LumberjacksLodge extends "res://gathering_unit_cls.gd"

const enums = preload("res://enums.gd")


func get_modifiers():
	return [0.3, 0.38, 0.5, 0.58, 0.75, 0.90, 1]


func get_upgrade_costs():
	return [100, 150, 200, 250, 300, 400, 500, 600, 700]


func get_unit_id():
	return 31


func get_unit_name():
	return "Lumberjack's Lodge"


func get_material():
	return "res://wood.png"


func get_resource():
	return enums.RESOURCE.WOOD


func _ready():
	pass


func _init(p, m, rm):
	pos = p
	map = m
	resources_map = rm
