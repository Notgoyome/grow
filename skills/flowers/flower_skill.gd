extends Skill
class_name FlowerSkill
@export var flower_instance: PackedScene
@export var flower_type: String
@export var area_zone: zone_size = zone_size.SINGLE

enum zone_size {
	CROSS,
	DIAG_CROSS,
	HORIZONTAL,
	VERTICAL,
	SINGLE
}

func use(tile_target: Tile) -> bool:
	if not can_use(tile_target):
		return false
	spawn_flowers(tile_target)
	return true

func can_use(tile_target: Tile) -> bool:
	return true


func setup_icon_ui(icon_ui: Node):
	var flower_ui: FlowerSkillUI = icon_ui as FlowerSkillUI
	flower_ui.change_type(flower_type)
	flower_ui.skill = self
	return flower_ui

func get_range() -> Array[Vector2i]:
	match area_zone:
		zone_size.CROSS:
			return [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
		zone_size.DIAG_CROSS:
			return [Vector2i(0, 0), Vector2i(1,1), Vector2i(-1,-1), Vector2i(1,-1), Vector2i(-1,1)]
		zone_size.HORIZONTAL:
			return [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0)]
		zone_size.VERTICAL:
			return [Vector2i(0, 0), Vector2i(0, 1), Vector2i(0, -1)]
		zone_size.SINGLE:
			return [Vector2i(0, 0)]
	return []

func spawn_flowers(tile_target: Tile):
	for vector in get_range():
		var neighbor_pos: Vector2i = tile_target.grid_position + vector
		var neighbor_tile: Tile = GameGlobal.map_manager.get_tile_at(neighbor_pos)
		if !neighbor_tile:
			continue
		spawn_flower(neighbor_tile)

func spawn_flower(tile_target: Tile):
	if !tile_target.can_have_object():
		return
	var flower: Flower = flower_instance.instantiate()
	tile_target.add_object(flower)
	flower.type = flower_type
	SignalBus.on_flower_planted.emit(tile_target, flower)

func recurse_transform_selected_flowers(tile: Tile, target: String, to: String):
	if !tile.is_occupied():
		return
	
	var flower: Flower = tile.object as Flower
	if !flower.type == target or flower.type == to:
		return
	flower.type = to

	var grid_position: Vector2i = tile.grid_position
	for direction in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var neighbor_pos: Vector2i = grid_position + direction
		var neighbor_tile: Tile = GameGlobal.map_manager.get_tile_at(neighbor_pos)
		if !neighbor_tile:
			continue
		recurse_transform_selected_flowers(neighbor_tile, target, to)
