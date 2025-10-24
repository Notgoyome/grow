extends Node2D
class_name Tile
@onready var display: Node2D = %Display
@onready var tile_indicator: TileIndicator = %TileIndicator
@onready var multiplier_label: Label = %MultiplierLabel
@onready var sprite_2d: AnimatedSprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer
var multiplier: int = 1:
	set(value):
		var old_multiplier = multiplier
		multiplier = min(max(value, 1), 512)
		var tween = get_tree().create_tween()
		var difference = multiplier - old_multiplier
		var total_time = min(difference * 0.10, 0.5)
		tween.tween_property(self, "multiplier_display", multiplier, total_time).set_ease(Tween.EASE_IN_OUT)
		animation_player.play("animate_label")
		

var multiplier_display : int = 1:
	set(value):
		multiplier_display = value
		_on_multiplier_display_changed()

var object: Node = null
var grid_position: Vector2i
var boolean_multiplier: bool = false
func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		SignalBus.on_tile_clicked.emit(self, event)

func _ready():
	SignalBus.on_skill_used.connect(_on_skill_used)
	_on_multiplier_changed()

func _on_skill_used(skill: Skill):
	var random_chance = randi() % 100
	if multiplier == 1:
		if random_chance < 5:
			multiplier *= 2
	else:
		if random_chance < 20:
			multiplier *= 2

	
func can_have_object() -> bool:
	return true

func add_object(obj: Node):
	if object:
		object.queue_free()
	add_child(obj)
	object = obj

func is_occupied() -> bool:
	return object != null

func get_neighbors() -> Array[Tile]:
	var neighbors: Array[Tile] = []
	var directions = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]
	for direction in directions:
		var neighbor_pos: Vector2i = grid_position + direction
		var neighbor_tile: Tile = GameGlobal.map_manager.get_tile_at(neighbor_pos)
		if neighbor_tile:
			neighbors.append(neighbor_tile)
	return neighbors

func get_score():
	if !(is_occupied() and object is Flower):
		return null

	return (object as Flower).get_score() * multiplier

func score_tile(flower_i: int = 0) -> int:
	var score = get_score()
	if score == null:
		return 0
	if object:
		object.crop_flower(float(flower_i)/10.0) #it's animation only
		object = null
	multiplier = 1
	return score

func _on_multiplier_changed():
	if multiplier == 1:
		multiplier_label.visible = false
	else:
		multiplier_label.visible = true
	multiplier_label.text = "x%d" % multiplier

func _on_multiplier_display_changed():
	
	# if multiplier_display >= 100:
	# 	display.scale = Vector2(0.6, 0.6)
	# elif multiplier_display >= 10:
	# 	display.scale = Vector2(1, 1)
	if multiplier_display > 1:
		multiplier_label.visible = true
	else:
		multiplier_label.visible = false
	multiplier_label.text = "x%d" % multiplier_display
