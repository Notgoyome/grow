extends Node

@export var player: Player
@onready var score_label: Label = %ScoreLabel


var current_score: int = 0:
	set(value):
		current_score = value
		on_tween_frame()
func _ready():
	SignalBus.on_flower_planted.connect(calculate_score)
	SignalBus.on_score_changed.connect(on_score_changed)
	on_score_changed(0)


func calculate_score(tile: Tile, flower: Node):
	var line_tiles: Array[Tile] = check_lines(tile, flower)
	if line_tiles.size() == 0:
		return

	var total_score = 0
	# for line_tile in line_tiles:
		
	for i in range(line_tiles.size()):
		var line_tile: Tile = line_tiles[i]
		total_score += line_tile.score_tile(i)

	var player_data: PlayerData = player.player_data
	player_data.score += total_score

func on_score_changed(new_score: int):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "current_score", new_score, 0.5)
	
func on_tween_frame():
	score_label.text = "Score: %d" % current_score

func check_lines(tile: Tile, flower: Node) -> Array[Tile]:
	var grid_position: Vector2i = tile.grid_position
	var map_manager = GameGlobal.map_manager
	var size = map_manager.map_size
	var line_tiles: Array[Tile] = []
	var line_tiles_y: Array[Tile] = []
	var is_line_completed = false

	for i in range(size.x):
		var current_tile = map_manager.get_tile_at(Vector2i(i, grid_position.y))
		if current_tile and current_tile.is_occupied() and current_tile.object is Flower:
			line_tiles.append(current_tile)
	if line_tiles.size() == size.x:
		is_line_completed = true
	else:
		line_tiles.clear()
	
	for i in range(size.y):
		var current_tile = map_manager.get_tile_at(Vector2i(grid_position.x, i))
		if current_tile and current_tile.is_occupied() and current_tile.object is Flower:
			line_tiles_y.append(current_tile)
	if line_tiles_y.size() == size.y:
		is_line_completed = true
	else:
		line_tiles_y.clear()

	if !is_line_completed:
		return []
	return line_tiles + line_tiles_y
