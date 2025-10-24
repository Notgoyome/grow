extends Node
class_name TileIndicator
@onready var indicator_display: Sprite2D = %IndicatorDisplay
var parent_tile: Tile = null
func _on_click_area_mouse_entered():
	SignalBus.on_tile_hovered.emit(parent_tile)
	show_indicator()

func _ready():
	var parent = get_parent()
	if not parent is Tile:
		return
	parent_tile = parent
	SignalBus.on_tile_hovered.connect(_on_tile_hovered)
	self.visible = false

func _on_tile_hovered(tile: Tile):
	if !tile:
		return
	parent_tile.tile_indicator.visible = false

func show_indicator():
	
	var skill: Skill = GameGlobal.selected_skill
	if skill == null:
		return
	var ranges: Array[Vector2i] = skill.get_range()
	var grid_position: Vector2i = parent_tile.grid_position
	print(ranges.size())
	for range in ranges:
		var neighbor_pos: Vector2i = grid_position + range
		var neighbor_tile: Tile = GameGlobal.map_manager.get_tile_at(neighbor_pos)
		if neighbor_tile:
			neighbor_tile.tile_indicator.visible = true
			print("Showing indicator on tile at position: ", neighbor_tile.grid_position)
