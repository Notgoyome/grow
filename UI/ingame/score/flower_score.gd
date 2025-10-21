extends Label

@export var flower_type: String = "red"

func _ready():
    SignalBus.on_flower_score_changed.connect(on_flower_score_changed)

func on_flower_score_changed(curr_flower_type: String, new_score: int):
    if curr_flower_type != self.flower_type:
        return
    text = "%s %d" % [flower_type, new_score]
    print("Updated flower score for %s: %d" % [flower_type, new_score])