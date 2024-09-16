extends Node
const game = preload("res://root.gd")
const TILEID_CLASSES = {
	game.TILE_BUILDING_LUMBERJACKS_LODGE: "LumberjacksLodge",
	game.TILE_BUILDING_FISHING_SITE: "FishingSite"
}
const TILEID_SCENES = {
	game.TILE_BUILDING_LUMBERJACKS_LODGE: "res://gathering_unit.tscn",
	game.TILE_BUILDING_FISHING_SITE: "res://gathering_unit.tscn"
}
