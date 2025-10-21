extends Node2D
class_name Tile

var object: Node = null
var grid_position: Vector2i

func _on_click_area_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		SignalBus.on_tile_clicked.emit(self, event)

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
