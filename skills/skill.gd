@abstract
extends Resource
class_name Skill

@export var name: String
@export var IconUI: PackedScene

@abstract func use(tile_target: Tile) -> bool
@abstract func can_use(tile_target: Tile) -> bool
@abstract func setup_icon_ui(icon_ui: Node)
