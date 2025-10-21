extends Node
class_name Player
@export var deck_manager: DeckManager
@export var player_data: PlayerData

func _ready():
	SignalBus.on_tile_clicked.connect(on_tile_clicked)

func on_tile_clicked(tile: Tile, event: InputEvent):
	event = event as InputEventMouseButton
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		deck_manager.on_tile_clicked(tile, event)
	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		recursive_crop(tile)
		pass


func recursive_crop(tile: Tile):
	if !tile.is_occupied():
		return
	var obj = tile.object
	if !obj is Flower:
		return
	increase_flower_score(obj.type, 1)
	tile.object.queue_free()
	tile.object = null
	var grid_position: Vector2i = tile.grid_position
	var neighbors_tiles = tile.get_neighbors()
	for neighbor_tile in neighbors_tiles:
		recursive_crop(neighbor_tile)

func increase_flower_score(flower_type: String, amount: int):
	player_data.increase_flower_score(flower_type, amount)
	SignalBus.on_flower_score_changed.emit(flower_type, player_data.get_flower_score(flower_type))