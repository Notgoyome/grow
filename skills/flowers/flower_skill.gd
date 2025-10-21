extends Skill
class_name FlowerSkill
@export var flower_instance: PackedScene
@export var flower_type: String

func use(tile_target: Tile) -> bool:
	if not can_use(tile_target):
		return false
	if !tile_target.is_occupied():
		spawn_flowers(tile_target)
	else:
		var flower = tile_target.object
		print("is flower: ", flower)
		print("type: ", flower.type)
		if !flower:
			print("Error: The object on the tile is not a Flower.")
			return false
		var current_type: String = flower.type
		recurse_transform_selected_flowers(tile_target, current_type, flower_type)

	return true

func can_use(tile_target: Tile) -> bool:
	return true


func setup_icon_ui(icon_ui: Node):
	var flower_ui: FlowerSkillUI = icon_ui as FlowerSkillUI
	flower_ui.change_type(flower_type)
	flower_ui.skill = self
	return flower_ui



func spawn_flowers(tile_target: Tile):
	var flower: Flower = flower_instance.instantiate()
	tile_target.add_object(flower)
	flower.type = flower_type
	for x in range(-1, 2):
		for y in range(-1, 2):
			if abs(x) + abs(y) > 1:
				continue
			var neighbor_pos: Vector2i = tile_target.grid_position + Vector2i(x, y)
			var neighbor_tile: Tile = GameGlobal.map_manager.get_tile_at(neighbor_pos)
			if !neighbor_tile:
				continue
			spawn_flower(neighbor_tile)

func spawn_flower(tile_target: Tile):
	var flower: Flower = flower_instance.instantiate()
	tile_target.add_object(flower)
	flower.type = flower_type

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
