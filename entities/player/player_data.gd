extends Resource
class_name PlayerData

var score: int = 0:
	set(value):
		score = value
		SignalBus.on_score_changed.emit(score)

