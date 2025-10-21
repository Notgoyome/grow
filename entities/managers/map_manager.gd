@tool
extends Node2D
class_name MapManager

@onready var tile = preload("res://entities/tiles/tile.tscn")
@onready var preview: CollisionShape2D = %Preview

@export_category("Map Settings")
@export var map_size: Vector2i = Vector2i(10, 10):
	set(value):
		var shape = %Preview.shape as RectangleShape2D
		var total_size_x = tile_size * (value.x + spacing) - spacing
		var total_size_y = tile_size * (value.y + spacing) - spacing
		shape.size = Vector2(total_size_x, total_size_y)
		%Preview.position = Vector2(total_size_x / 2, total_size_y / 2)
		map_size = value
@export var tile_size = 16
@export var spacing = 1

var _tiles := []
func _ready():
	#check if in editor or not
	if Engine.is_editor_hint():
		return
	GameGlobal.map_manager = self
	generate_map()
	pass

func generate_map():
	clear_map()
	for x in range(map_size.x):
		_tiles.append([])
		for y in range(map_size.y):
			var new_tile = tile.instantiate()
			new_tile.position = Vector2(
				x * (tile_size + spacing),
				y * (tile_size + spacing)
			)
			new_tile.grid_position = Vector2i(x, y)
			add_child(new_tile)
			_tiles[x].append(new_tile)

func get_tile_at(grid_position: Vector2i) -> Tile:
	if grid_position.x < 0 or grid_position.x >= map_size.x:
		return null
	if grid_position.y < 0 or grid_position.y >= map_size.y:
		return null
	return _tiles[grid_position.x][grid_position.y]

func clear_map():
	for column in _tiles:
		for tile in column:
			tile.queue_free()
	_tiles.clear()
